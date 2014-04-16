class AccountSerializer < BaseSerializer
  attributes :name, :slug, :website_url, :webhook_url, :prefers_archiving
end
