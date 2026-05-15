using CarStockAPI.Repositories;
using Dapper;
using FastEndpoints;
using Microsoft.Data.Sqlite;

namespace CarStockAPI.Features.Sales
{
    public class UpdateSaleStatusRequest
    {
        public string Status { get; set; } = string.Empty;
    }

    public class UpdateSaleStatusEndpoint : Endpoint<UpdateSaleStatusRequest>
    {
        private readonly SalesRepository _repo;

        public UpdateSaleStatusEndpoint(SalesRepository repo) { _repo = repo; }

        public override void Configure() { Put("/api/sales/{id}/status"); }

        public override async Task HandleAsync(UpdateSaleStatusRequest req, CancellationToken ct)
        {
            var validStatuses = new[] { "Pending", "Completed", "Cancelled" };
            if (!validStatuses.Contains(req.Status))
            {
                AddError(r => r.Status, $"Status must be one of: {string.Join(", ", validStatuses)}");
                await Send.ErrorsAsync(400);
                return;
            }

            var id = Route<int>("id");
            var dealerId = int.Parse(User.FindFirst("dealerId")!.Value);
            var found = await _repo.UpdateStatus(id, dealerId, req.Status);

            if (!found) { await Send.NotFoundAsync(); return; }
            await Send.OkAsync();
        }
    }
}