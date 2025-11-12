using System.ComponentModel.DataAnnotations.Schema;

namespace TransferAPI.Models
{
    [Table("Accounts", Schema = "test")]
    public class Accounts
    {
        public int id { get; set; }
        public string user_name { get; set; }
        public double balance { get; set; }
    }
}
