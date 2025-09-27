/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  // Create donations collection
  const donationsCollection = new Collection({
    "id": "donations_collection",
    "created": "2024-01-01 00:00:00.000Z",
    "updated": "2024-01-01 00:00:00.000Z",
    "name": "donations",
    "type": "base",
    "system": false,
    "schema": [
      {
        "system": false,
        "id": "donor_name",
        "name": "donor_name",
        "type": "text",
        "required": true,
        "presentable": false,
        "unique": false,
        "options": {
          "min": null,
          "max": null,
          "pattern": ""
        }
      },
      {
        "system": false,
        "id": "donor_organization",
        "name": "donor_organization",
        "type": "text",
        "required": false,
        "presentable": false,
        "unique": false,
        "options": {
          "min": null,
          "max": null,
          "pattern": ""
        }
      },
      {
        "system": false,
        "id": "amount",
        "name": "amount",
        "type": "number",
        "required": true,
        "presentable": false,
        "unique": false,
        "options": {
          "min": 0,
          "max": null,
          "noDecimal": false
        }
      },
      {
        "system": false,
        "id": "currency",
        "name": "currency",
        "type": "select",
        "required": true,
        "presentable": false,
        "unique": false,
        "options": {
          "maxSelect": 1,
          "values": [
            "USD",
            "EUR",
            "GBP",
            "SAR",
            "AED",
            "JOD",
            "EGP",
            "LBP",
            "SYP",
            "IQD"
          ]
        }
      },
      {
        "system": false,
        "id": "payment_method",
        "name": "payment_method",
        "type": "select",
        "required": true,
        "presentable": false,
        "unique": false,
        "options": {
          "maxSelect": 1,
          "values": [
            "Cash",
            "Bank Transfer",
            "Credit Card",
            "PayPal",
            "Cryptocurrency",
            "Check",
            "Mobile Payment",
            "Other"
          ]
        }
      },
      {
        "system": false,
        "id": "purpose",
        "name": "purpose",
        "type": "text",
        "required": false,
        "presentable": false,
        "unique": false,
        "options": {
          "min": null,
          "max": null,
          "pattern": ""
        }
      },
      {
        "system": false,
        "id": "receipt_number",
        "name": "receipt_number",
        "type": "text",
        "required": false,
        "presentable": false,
        "unique": false,
        "options": {
          "min": null,
          "max": null,
          "pattern": ""
        }
      },
      {
        "system": false,
        "id": "donor_contact",
        "name": "donor_contact",
        "type": "text",
        "required": false,
        "presentable": false,
        "unique": false,
        "options": {
          "min": null,
          "max": null,
          "pattern": ""
        }
      },
      {
        "system": false,
        "id": "notes",
        "name": "notes",
        "type": "text",
        "required": false,
        "presentable": false,
        "unique": false,
        "options": {
          "min": null,
          "max": null,
          "pattern": ""
        }
      },
      {
        "system": false,
        "id": "recorded_by",
        "name": "recorded_by",
        "type": "relation",
        "required": true,
        "presentable": false,
        "unique": false,
        "options": {
          "collectionId": "_pb_users_auth_",
          "cascadeDelete": false,
          "minSelect": null,
          "maxSelect": 1,
          "displayFields": null
        }
      }
    ],
    "indexes": [],
    "listRule": null,
    "viewRule": null,
    "createRule": null,
    "updateRule": null,
    "deleteRule": null,
    "options": {}
  });

  // Create expenses collection
  const expensesCollection = new Collection({
    "id": "expenses_collection",
    "created": "2024-01-01 00:00:00.000Z",
    "updated": "2024-01-01 00:00:00.000Z",
    "name": "expenses",
    "type": "base",
    "system": false,
    "schema": [
      {
        "system": false,
        "id": "category",
        "name": "category",
        "type": "select",
        "required": true,
        "presentable": false,
        "unique": false,
        "options": {
          "maxSelect": 1,
          "values": [
            "Medical Supplies",
            "Food & Water",
            "Transportation",
            "Shelter Materials",
            "Clothing",
            "Equipment",
            "Administrative",
            "Communication",
            "Fuel",
            "Emergency Response",
            "Education Materials",
            "Other"
          ]
        }
      },
      {
        "system": false,
        "id": "amount",
        "name": "amount",
        "type": "number",
        "required": true,
        "presentable": false,
        "unique": false,
        "options": {
          "min": 0,
          "max": null,
          "noDecimal": false
        }
      },
      {
        "system": false,
        "id": "currency",
        "name": "currency",
        "type": "select",
        "required": true,
        "presentable": false,
        "unique": false,
        "options": {
          "maxSelect": 1,
          "values": [
            "USD",
            "EUR",
            "GBP",
            "SAR",
            "AED",
            "JOD",
            "EGP",
            "LBP",
            "SYP",
            "IQD"
          ]
        }
      },
      {
        "system": false,
        "id": "vendor_supplier",
        "name": "vendor_supplier",
        "type": "text",
        "required": false,
        "presentable": false,
        "unique": false,
        "options": {
          "min": null,
          "max": null,
          "pattern": ""
        }
      },
      {
        "system": false,
        "id": "receipt_invoice_number",
        "name": "receipt_invoice_number",
        "type": "text",
        "required": false,
        "presentable": false,
        "unique": false,
        "options": {
          "min": null,
          "max": null,
          "pattern": ""
        }
      },
      {
        "system": false,
        "id": "project_campaign",
        "name": "project_campaign",
        "type": "text",
        "required": false,
        "presentable": false,
        "unique": false,
        "options": {
          "min": null,
          "max": null,
          "pattern": ""
        }
      },
      {
        "system": false,
        "id": "description",
        "name": "description",
        "type": "text",
        "required": true,
        "presentable": false,
        "unique": false,
        "options": {
          "min": null,
          "max": null,
          "pattern": ""
        }
      },
      {
        "system": false,
        "id": "receipt_files",
        "name": "receipt_files",
        "type": "file",
        "required": false,
        "presentable": false,
        "unique": false,
        "options": {
          "maxSelect": 5,
          "maxSize": 5242880,
          "mimeTypes": [
            "image/jpeg",
            "image/png",
            "image/gif",
            "application/pdf"
          ],
          "thumbs": [
            "100x100"
          ],
          "protected": false
        }
      },
      {
        "system": false,
        "id": "approved_by",
        "name": "approved_by",
        "type": "relation",
        "required": true,
        "presentable": false,
        "unique": false,
        "options": {
          "collectionId": "_pb_users_auth_",
          "cascadeDelete": false,
          "minSelect": null,
          "maxSelect": 1,
          "displayFields": null
        }
      },
      {
        "system": false,
        "id": "recorded_by",
        "name": "recorded_by",
        "type": "relation",
        "required": true,
        "presentable": false,
        "unique": false,
        "options": {
          "collectionId": "_pb_users_auth_",
          "cascadeDelete": false,
          "minSelect": null,
          "maxSelect": 1,
          "displayFields": null
        }
      },
      {
        "system": false,
        "id": "status",
        "name": "status",
        "type": "select",
        "required": true,
        "presentable": false,
        "unique": false,
        "options": {
          "maxSelect": 1,
          "values": [
            "Pending",
            "Approved",
            "Rejected"
          ]
        }
      }
    ],
    "indexes": [],
    "listRule": null,
    "viewRule": null,
    "createRule": null,
    "updateRule": null,
    "deleteRule": null,
    "options": {}
  });

  return Dao(db).saveCollection(donationsCollection) && Dao(db).saveCollection(expensesCollection);
}, (db) => {
  // Rollback - delete the collections
  const dao = new Dao(db);
  
  try {
    dao.deleteCollection(dao.findCollectionByNameOrId("donations"));
  } catch (e) {
    console.log("donations collection not found during rollback");
  }
  
  try {
    dao.deleteCollection(dao.findCollectionByNameOrId("expenses"));
  } catch (e) {
    console.log("expenses collection not found during rollback");
  }
  
  return true;
});

