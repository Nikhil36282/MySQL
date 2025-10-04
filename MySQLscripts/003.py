import pdfplumber
import pandas as pd
import re

pdf_file = "/mnt/n/Downloads/PhonePe_Statement_Aug2025_Aug2025.pdf"
data = []

# Regex patterns
date_re = re.compile(r'([A-Za-z]{3,9}\s\d{1,2},\s\d{4})')
amount_re = re.compile(r'₹([\d,.]+)')
payment_mode_re = re.compile(r'(DEBIT|CREDIT)')
vendor_keywords = ['Paid to', 'Mobile recharged', 'Payment to', 'Transfer to', 'FASTag Recharge','Received from']

with pdfplumber.open(pdf_file) as pdf:
    for page in pdf.pages:
        text = page.extract_text()
        if not text:
            continue
        lines = [re.sub(r'\s+', ' ', l).strip() for l in text.split('\n') if l.strip()]

        trx_lines = []
        for line in lines:
            # Check if this line is a new transaction (starts with a date)
            if date_re.match(line):
                # Process previous transaction
                if trx_lines:
                    trx_text = " ".join(trx_lines)
                    # Extract info
                    date_match = date_re.search(trx_text)
                    amount_match = amount_re.search(trx_text)
                    payment_match = payment_mode_re.search(trx_text)
                    vendor_match = None
                    for kw in vendor_keywords:
                        if kw in trx_text:
                            vendor_match = re.search(rf'{kw}\s+(.*?)\s+(DEBIT|CREDIT|₹)', trx_text)
                            break
                    if date_match and amount_match and payment_match and vendor_match:
                        spend_date = pd.to_datetime(date_match.group(1).replace("Sept", "Sep"), errors='coerce')
                        vendor = vendor_match.group(1).strip()
                        payment_mode = payment_match.group(1).strip()
                        amount = float(amount_match.group(1).replace(',', ''))
                        data.append({
                            'spend_date': spend_date,
                            'vendor': vendor,
                            'payment_mode': payment_mode,
                            'amount': amount,
                            'category': 'Uncategorized',
                            'notes': ''
                        })
                trx_lines = [line]  # start new transaction
            else:
                trx_lines.append(line)

        # Process last transaction on page
        if trx_lines:
            trx_text = " ".join(trx_lines)
            date_match = date_re.search(trx_text)
            amount_match = amount_re.search(trx_text)
            payment_match = payment_mode_re.search(trx_text)
            vendor_match = None
            for kw in vendor_keywords:
                if kw in trx_text:
                    vendor_match = re.search(rf'{kw}\s+(.*?)\s+(DEBIT|CREDIT|₹)', trx_text)
                    break
            if date_match and amount_match and payment_match and vendor_match:
                spend_date = pd.to_datetime(date_match.group(1).replace("Sept", "Sep"), errors='coerce')
                vendor = vendor_match.group(1).strip()
                payment_mode = payment_match.group(1).strip()
                amount = float(amount_match.group(1).replace(',', ''))
                data.append({
                    'spend_date': spend_date,
                    'vendor': vendor,
                    'payment_mode': payment_mode,
                    'amount': amount,
                    'category': 'Uncategorized',
                    'notes': ''
                })

# Save to CSV
df = pd.DataFrame(data)
df.to_csv("PhonePe_spends_aug.csv", index=False)
print("CSV file created:", "PhonePe_spends_aug.csv")
print("Total parsed transactions:", len(df))
print(df.head(10))

