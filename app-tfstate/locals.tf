locals {
  tfstate           = join("", [var.role, ".tfstate"])
  tfstate_store     = join("", [var.product, "tfstr",var.location, var.environment])
}

locals {
  tags = {
    product     = var.product
    environment = var.environment
    squad       = var.squad
    description = var.description
    tfstate     = "https://${local.tfstate_store}.blob.core.windows.net/tfstate/${local.tfstate}"
  }
}
