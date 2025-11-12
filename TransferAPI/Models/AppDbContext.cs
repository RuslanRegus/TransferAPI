    using Microsoft.EntityFrameworkCore;

    namespace TransferAPI.Models
    {
        public class AppDbContext: DbContext
        {
            public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }
            public DbSet<Transactions> Transactions { get; set; }
            public DbSet<Accounts> Accounts { get; set; }
        }
    }
