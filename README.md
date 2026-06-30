# AD Trust Repair Tool

An automated Batch/PowerShell script designed for IT Administrators and Support teams to quickly repair Active Directory Domain Trust Relationship issues ("The trust relationship between this workstation and the primary domain failed").

เครื่องมือสำหรับสาย IT Support เพื่อใช้ซ่อมแซมปัญหา Domain Trust หลุดแบบอัตโนมัติ โดยไม่ต้องพิมพ์คำสั่งเองให้ยุ่งยาก พร้อมระบบตรวจสอบสิทธิ์ Admin และแจ้งเตือนผ่าน GUI

## ✨ Features (คุณสมบัติเด่น)

* **Automated Repair:** Uses PowerShell's `Test-ComputerSecureChannel -Repair` in the background.
* **Auto UAC / Admin Check:** ตรวจสอบสิทธิ์ Administrator อัตโนมัติ หากผู้ใช้ไม่ได้ Run as Admin หน้าจอจะเปลี่ยนเป็นสีแดงกระพริบ พร้อมแจ้งเตือนให้เปิดแบบ Admin
* **GUI Notifications:** แจ้งผลการทำงาน (Success/Failed) ผ่านหน้าต่าง Message Box (GUI)
* **Self-Destruct Mechanism:** มีระบบถามเพื่อลบไฟล์สคริปต์ทิ้งทันทีหลังจากซ่อมแซมเสร็จสิ้น (ป้องกันผู้ใช้ทั่วไปนำไปกดเล่นซ้ำ)
* **Visual Progress:** มีแถบ Progress bar จำลองบน Command Line เพื่อให้ผู้ใช้ทราบว่าระบบกำลังทำงาน

## 🚀 How to Use (วิธีใช้งาน)

1. เปิดไฟล์สคริปต์ด้วย Text Editor (เช่น Notepad)
2. แก้ไขตัวแปรในส่วนของ **MAIN SCRIPT** ให้เป็นข้อมูลขององค์กรคุณ:
   ```bat
   set "MY_DOMAIN=yourdomain.local"
   set "MY_USER=admin_username"
   set "MY_PASS=admin_password"
   ```
3. บันทึกไฟล์เป็นนามสกุล .bat
4. นำไปรันบนเครื่องที่มีปัญหา โดยคลิกขวาที่ไฟล์แล้วเลือก Run as administrator
5. รอระบบทำงานและทำตามคำแนะนำบนหน้าจอ Message Box
