namespace TransferAPI.Models
{
    public class TransactionsDTO
    {

        public int from_account_id { get; set; }
        public int to_account_id { get; set; }
        public double amount { get; set; }
        public string idempotency_key { get; set; } = string.Empty;
    }
}
