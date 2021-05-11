using Microsoft.EntityFrameworkCore;

namespace MyStockMarketWalletAPI.Models
{
    public class MyStockMarketWalletContext : DbContext
    {
        public MyStockMarketWalletContext(DbContextOptions<MyStockMarketWalletContext> options)
            : base(options)
        {
        }

        public DbSet<Stock> Stocks { get; set; }
    }
}
