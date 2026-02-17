# Quick Start: Custom Ingredients Import/Export

## Export Your Custom Ingredients

### Steps

1. Open the app and navigate to **"Stored Ingredients"**
2. Scroll down to **"Your Custom Ingredients"** section
3. Click the **download icon** (📥) in the header
4. Choose format:
   - **JSON** - Better for programmatic use, human-readable
   - **CSV** - Works with Excel/Sheets, easy to edit
5. File saved as `custom_ingredients_<timestamp>.json` or `.csv`
6. Check snackbar message for file location

### File Location

- **Android:** `/data/data/com.example.feed_estimator/files/`
- Use a file manager app or `adb pull` to retrieve

---

## Import Custom Ingredients

### Preparation

1. Place your file in the app documents directory:

   ```bash
   # Via ADB (Android Debug Bridge)
   adb push my_ingredients.json /data/data/com.example.feed_estimator/files/
   ```

   Or use a file manager app with root access

### Steps

1. Open the app and navigate to **"Stored Ingredients"**
2. Scroll down to **"Your Custom Ingredients"** section
3. Click the **upload icon** (📤) in the header
4. Choose format matching your file: **JSON** or **CSV**
5. Enter filename (without extension):
   - Type: `my_ingredients` for `my_ingredients.json`
   - Or leave empty to use default: `custom_ingredients`
6. Click **Import**
7. Check snackbar for success message: "Imported X of Y ingredients"

---

## Editing CSV in Excel/Google Sheets

### Open CSV

1. Export to CSV from app
2. Retrieve file from device
3. Open in Excel or Google Sheets

### Columns (in order)

```
id, name, category, dm, cp, ee, cf, ash, nfe, de, me, ca, ph, ly, 
me_th, tdn, favourite, is_custom, created_by, created_date, notes, price
```

### Edit Rules

- **name:** Required, text (e.g., "Custom Fish Meal")
- **category:** Number 1-7 (1=Energy, 2=Protein, 3=Vitamin, etc.)
- **dm, cp, ee, cf, ash, nfe:** Percentages (0-100)
- **de, me:** Energy values (Mcal/kg)
- **ca, ph, ly:** Mineral percentages
- **me_th, tdn:** Optional energy metrics
- **favourite:** 0 or 1 (1 = starred)
- **is_custom:** Always 1 for custom ingredients
- **created_by:** Your name or "User"
- **created_date:** Unix timestamp (milliseconds)
- **notes:** Optional description (use quotes if contains commas)
- **price:** Cost per unit

### Special Characters

- If cell contains comma or newline, wrap in quotes: `"High protein, premium quality"`
- To include quotes, double them: `"He said ""excellent"""`

### Save

- Save as CSV (UTF-8)
- Re-import to app

---

## Troubleshooting

### "File not found" error

- **Check filename:** Must match exactly (case-sensitive)
- **Check location:** File must be in app documents directory
- **Check extension:** Don't include `.json` or `.csv` in filename field

### "Import failed" error

- **CSV format:** Ensure 22 columns with correct headers
- **JSON format:** Validate JSON syntax (use jsonlint.com)
- **Category IDs:** Must be 1-7 (valid category)
- **Required fields:** `name` and `categoryId` cannot be empty

### Import shows "0 of X imported"

- **Duplicate IDs:** If importing with same IDs as existing ingredients
- **Database constraint:** Check ingredient name doesn't conflict
- **Review logs:** Check app console for specific errors

### Export shows empty file

- **No custom ingredients:** Must have at least one custom ingredient created
- **Permissions:** App needs write access to documents directory

---

## Advanced: Programmatic Import/Export

### Generate JSON Programmatically

```json
[
  {
    "ingredientId": null,
    "name": "Custom Soybean Meal",
    "categoryId": 2,
    "dm": 89.0,
    "cp": 48.5,
    "ee": 1.0,
    "cf": 3.5,
    "ash": 6.5,
    "nfe": 29.5,
    "de": 3.1,
    "me": 2.9,
    "ca": 0.3,
    "ph": 0.7,
    "ly": 3.0,
    "meTh": 2900,
    "tdn": 82,
    "favourite": 1,
    "isCustom": 1,
    "createdBy": "Nutritionist",
    "createdDate": 1735689600000,
    "notes": "High-quality processed meal",
    "price": 350.5
  }
]
```

### Generate CSV Programmatically

```python
import csv
from datetime import datetime

ingredients = [
    {
        'id': '',
        'name': 'Custom Soybean Meal',
        'category': 2,
        'dm': 89.0,
        'cp': 48.5,
        # ... other fields
        'notes': 'High-quality processed meal',
        'price': 350.5
    }
]

with open('custom_ingredients.csv', 'w', newline='') as f:
    writer = csv.DictWriter(f, fieldnames=ingredients[0].keys())
    writer.writeheader()
    writer.writerows(ingredients)
```

---

## Batch Operations

### Export Multiple Profiles

1. Export custom ingredients: `user_profile_1.json`
2. Create new custom ingredients in app
3. Export again: `user_profile_2.json`
4. Import either profile as needed

### Merge Ingredients

1. Export current custom ingredients
2. Edit JSON/CSV to add new entries
3. Import merged file (duplicates handled automatically)

### Share with Team

1. Export to CSV/JSON
2. Share file via email/messaging
3. Team members import to their devices

---

## Tips & Best Practices

### Backup Regularly

- Export after creating valuable custom ingredients
- Keep backups on cloud storage (Google Drive, Dropbox)

### Naming Convention

- Use descriptive names: `custom_fish_meal_premium` not `fish1`
- Include source/quality in name: `Soybean Meal (Argentina, 48% CP)`

### Documentation

- Use `notes` field for detailed information
- Include supplier, batch number, test date

### Categories

1. Energy Sources
2. Protein Sources
3. Vitamin & Mineral
4. Additives & Supplements
5. Forage & Roughage
6. Byproducts
7. Other

### Testing

- Import test file with 1-2 ingredients first
- Verify data accuracy before bulk import
- Keep original file as backup

---

## Example Workflow

### Scenario: Feed Consultant Managing Multiple Farms

1. **Farm A - Initial Setup:**
   - Create 10 custom local ingredients in app
   - Export to `farm_a_ingredients.json`
   - Backup to Google Drive

2. **Farm B - Reuse Ingredients:**
   - Download `farm_a_ingredients.json` from Drive
   - Edit in text editor to adjust prices
   - Push to device: `adb push farm_a_ingredients.json /data/...`
   - Import in app on Farm B device

3. **Farm C - Custom Mix:**
   - Export Farm A and Farm B ingredients
   - Merge JSON arrays in text editor
   - Import merged file to Farm C device

4. **Quarterly Update:**
   - Export all farm ingredients
   - Update prices in CSV using Excel
   - Re-import to all devices

---

## Support

### Need Help?

- Check logs for detailed error messages
- Verify CSV/JSON format using online validators
- Test with sample file (1-2 ingredients) first

### Feature Requests

- File picker for easier import
- Share button for direct file sharing
- Cloud backup integration

---

**Version:** Phase 2 Complete  
**Last Updated:** 2025-01-XX  
**Build:** app-debug.apk
