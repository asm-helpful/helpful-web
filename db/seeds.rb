# Rough billing outline
# These are some example IDs that correspond to the Chargify dev subdomain 'helpful-dev'
BillingPlan.create slug: 'bronze',
                   name: "Bronze",
                   chargify_product_id: '3362368',
                   max_conversations: 25,
                   price: 39

BillingPlan.create slug: 'silver',
                   name: "Silver",
                   chargify_product_id: '3362369',
                   max_conversations: 250,
                   price: 99

BillingPlan.create slug: 'gold',
                   name: "Gold",
                   chargify_product_id: '3362370',
                   max_conversations: 1000,
                   price: 199
