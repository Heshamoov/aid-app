const PocketBase = require('pocketbase/cjs')
const pb = new PocketBase('http://127.0.0.1:8090' )

async function createCollections() {
  try {
    // Login as admin
    await pb.admins.authWithPassword('heshamoov90@gmail.com', 'TobeornoTTobe')
    
    await pb.collections.create({
      name: 'expenses',
      type: 'base',
      schema: [
        { name: 'category', type: 'select', required: true, options: { values: ['Medical Supplies', 'Food & Water', 'Transportation', 'Other'] }},
        { name: 'amount', type: 'number', required: true },
        { name: 'currency', type: 'select', required: true, options: { values: ['USD', 'EUR', 'SAR', 'AED'] }},
        { name: 'description', type: 'text', required: true },
        { name: 'status', type: 'select', required: true, options: { values: ['Pending', 'Approved', 'Rejected'] }}
      ]
    })
    
    console.log('Collections created!')
  } catch (error) {
    console.error('Error:', error)
  }
}

createCollections()