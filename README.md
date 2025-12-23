# Azure Lab IaC (Terraform)

This repo provisions a minimal lab environment in Azure with:

- Site-to-site VPN gateway (BGP-enabled) for FortiGate
- Microsoft Entra Domain Services (Azure AD DS)

## Cost estimate (approximate)

> Pricing varies by region and usage. Validate in the Azure Pricing Calculator.

| Component | SKU | Estimated monthly cost (USD) | Notes |
| --- | --- | --- | --- |
| VPN gateway | VpnGw1 | ~$35–$45 | Required for BGP; includes active tunnel hours. |
| Public IP | Basic | ~$0 | Basic IP generally included with gateway usage. |
| Entra AD DS | Standard | ~$109 | Smallest SKU with 24/7 availability. |

**Cost reduction tip:** The VPN gateway and Entra AD DS are billed while deployed. For lab-only usage, delete and recreate the resources when not in use.

## Usage

```bash
terraform init
terraform apply \
  -var="onprem_vpn_public_ip=203.0.113.10" \
  -var="onprem_bgp_asn=65010" \
  -var="onprem_bgp_peering_address=10.10.0.1" \
  -var="ipsec_shared_key=CHANGEME"
```

## Notes

- Default region is `westus` (closest to Northern Nevada for latency/cost trade-off).
- Address spaces:
  - On-prem: `10.10.0.0/16`
  - Azure VNet: `10.20.0.0/16`
- Update variables in `variables.tf` for your lab.
