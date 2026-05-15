using CarStockAPI.Repositories;
using FastEndpoints;

namespace CarStockAPI.Features.Customers
{
    public class UpdateCustomerRequest
    {
        public string Name { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string? Phone { get; set; }
    }

    public class UpdateCustomerEndpoint : Endpoint<UpdateCustomerRequest>
    {
        private readonly CustomerRepository _repo;

        public UpdateCustomerEndpoint(CustomerRepository repo) { _repo = repo; }

        public override void Configure() { Put("/api/customers/{id}"); }

        public override async Task HandleAsync(UpdateCustomerRequest req, CancellationToken ct)
        {
            if (string.IsNullOrWhiteSpace(req.Name))
            {
                AddError(r => r.Name, "Name is required");
                await Send.ErrorsAsync(); return;
            }
            if (string.IsNullOrWhiteSpace(req.Email))
            {
                AddError(r => r.Email, "Email is required");
                await Send.ErrorsAsync(); return;
            }

            var id = Route<int>("id");
            var dealerId = int.Parse(User.FindFirst("dealerId")!.Value);
            var found = await _repo.Update(id, dealerId, req.Name, req.Email, req.Phone ?? "");

            if (!found) { await Send.NotFoundAsync(); return; }
            await Send.OkAsync();
        }
    }
}