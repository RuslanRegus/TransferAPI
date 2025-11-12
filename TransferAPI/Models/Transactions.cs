using System.ComponentModel.DataAnnotations.Schema;

namespace TransferAPI.Models
{
    [Table("Transactions", Schema = "test")]
    public class Transactions
    {
        public int id { get; set; }
        public int from_account_id { get; set; }
        public int to_account_id { get; set; }
        public double amount { get; set; }
        public DateTime timestamp { get; set; }

        public string idempotency_key { get; set; } = string.Empty;
        public Transactions() { }

        public Transactions(int fromAccountId, int toAccountId, double amount, DateTime timestamp)
        {
            this.from_account_id = fromAccountId;
            this.to_account_id = toAccountId;
            this.amount = amount;
            this.timestamp = timestamp;
        }
    }
}
