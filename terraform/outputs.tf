output "openai_endpoint" { value = azurerm_cognitive_account.openai.endpoint }
output "apim_gateway_url" { value = azurerm_api_management.apim.gateway_url }
output "search_endpoint" { value = "https://${azurerm_search_service.search.name}.search.windows.net" }
output "openai_name" { value = azurerm_cognitive_account.openai.name }
output "search_name" { value = azurerm_search_service.search.name }
