using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Runtime.ConstrainedExecution;
using TransferAPI.Models;

namespace TransferAPI.Controllers
{
    [Route("api/transfer")]
    [ApiController]
    public class TransferController : Controller
    {
        private readonly AppDbContext _context;

        public TransferController(AppDbContext context)
        {
            _context = context;
        }

        [HttpPost]
        public async Task<IActionResult> PostTransfer([FromBody] TransactionsDTO transactionsDTO)
        {
            //prevent duplicate processing
            var existingTransaction = await _context.Transactions
                .FirstOrDefaultAsync(t => t.idempotency_key == transactionsDTO.idempotency_key);

            if (existingTransaction != null)
            {
                return Ok(new
                {
                    message = "Duplicate request ignored. Transaction already processed.",
                    transaction_id = existingTransaction.id,
                    from_account_id = existingTransaction.from_account_id,
                    to_account_id = existingTransaction.to_account_id,
                    amount = existingTransaction.amount,
                    timestamp = existingTransaction.timestamp
                });
            }

            //if TransactionsDTO is null
            if (transactionsDTO == null)
                return BadRequest("Invalid transfer data.");

            //if sender = receiver
            if (transactionsDTO.from_account_id == transactionsDTO.to_account_id)
                return BadRequest("Sender and receiver accounts must be different.");

            //check if amount is positive
            if (transactionsDTO.amount <= 0)
                return BadRequest("Transfer amount must be positive.");

            using var dbTransaction = await _context.Database.BeginTransactionAsync();
            try
            {
                //1 check if both accounts exist
                var fromAccount = await _context.Accounts
                    .FirstOrDefaultAsync(a => a.id == transactionsDTO.from_account_id);
                var toAccount = await _context.Accounts
                    .FirstOrDefaultAsync(a => a.id == transactionsDTO.to_account_id);

                if (fromAccount == null)
                {
                    await dbTransaction.RollbackAsync();
                    return NotFound($"Account with id {transactionsDTO.from_account_id} not found.");
                }

                if (toAccount == null)
                {
                    await dbTransaction.RollbackAsync();
                    return NotFound($"Account with id {transactionsDTO.to_account_id} not found.");
                }

                //3 check if sender has enough money
                if (fromAccount.balance < transactionsDTO.amount)
                {
                    await dbTransaction.RollbackAsync();
                    return BadRequest("Insufficient funds.");
                }

                //4 reduce from sender
                fromAccount.balance -= transactionsDTO.amount;

                //5 add to receiver
                toAccount.balance += transactionsDTO.amount;

                //6 add new record transaction
                var transaction = new Transactions(
                    transactionsDTO.from_account_id,
                    transactionsDTO.to_account_id,
                    transactionsDTO.amount,
                    DateTime.UtcNow
                );
                transaction.idempotency_key = transactionsDTO.idempotency_key;

                _context.Transactions.Add(transaction);
                await _context.SaveChangesAsync();
                await dbTransaction.CommitAsync();

                return Ok(new
                {
                    message = "Transfer completed successfully.",
                    transaction_id = transaction.id,
                    sender_balance = fromAccount.balance,
                    receiver_balance = toAccount.balance
                });
            }
            catch (Exception ex)
            {
                await dbTransaction.RollbackAsync();
                return StatusCode(500, $"Transaction failed: {ex.Message}");
            }
        }
    }
}