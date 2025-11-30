# Terminalden Çalıştırma Rehberi (Windows PowerShell)

## Hızlı Başlangıç

### Yöntem 1: PowerShell Script Kullanarak (Önerilen)

```powershell
cd "C:\Program Files\nodejs\kurumsal-proje\backend"
.\START-DEV.ps1
```

### Yöntem 2: Manuel Adımlar

#### 1. Backend klasörüne gidin:
```powershell
cd "C:\Program Files\nodejs\kurumsal-proje\backend"
```

#### 2. PostgreSQL servisini kontrol edin ve başlatın:
```powershell
# PostgreSQL servis adını bulun
Get-Service | Where-Object { $_.Name -like "*postgres*" }

# Servisi başlatın (bulduğunuz servis adını kullanın)
Start-Service postgresql-x64-14  # Servis adı farklı olabilir
```

**Alternatif:** PostgreSQL servisini Windows Services (services.msc) üzerinden de başlatabilirsiniz.

#### 3. .env dosyasını kontrol edin:
```powershell
# .env dosyası yoksa oluşturun
if (-not (Test-Path .env)) {
    Copy-Item env.example .env
}
```

#### 4. Dev server'ı başlatın:
```powershell
npm run dev
```

## Önemli Notlar

### PowerShell Komut Ayırıcıları

PowerShell'de komutları birleştirmek için `&&` yerine `;` kullanın:

✅ **Doğru:**
```powershell
cd backend; npm run dev
```

❌ **Yanlış:**
```powershell
cd backend && npm run dev  # PowerShell'de çalışmaz
```

### Tüm npm Scriptleri

```powershell
cd "C:\Program Files\nodejs\kurumsal-proje\backend"

npm run dev          # Dev server (hot-reload)
npm run build        # TypeScript derleme
npm start            # Production server
npm run migrate      # Veritabanı migration'ları
npm run hash-passwords  # Seed kullanıcı şifrelerini hashle
```

### PostgreSQL Bağlantı Sorunları

Eğer `ECONNREFUSED` hatası alıyorsanız:

1. **PostgreSQL servisinin çalıştığından emin olun:**
   ```powershell
   Get-Service | Where-Object { $_.Name -like "*postgres*" }
   ```

2. **PostgreSQL'in 5432 portunda dinlediğini kontrol edin:**
   ```powershell
   netstat -an | findstr 5432
   ```

3. **.env dosyasındaki DATABASE_URL'i kontrol edin:**
   ```
   DATABASE_URL=postgresql://postgres:postgres@localhost:5432/kurumsal
   ```

4. **PostgreSQL'i başlatın:**
   - Windows Services üzerinden (services.msc)
   - Veya PowerShell ile: `Start-Service <servis-adı>`

## Troubleshooting

### "tsx: command not found" hatası
```powershell
npm install
```

### "node_modules bulunamadı" hatası
```powershell
cd "C:\Program Files\nodejs\kurumsal-proje\backend"
npm install
```

### Permission hatası
PowerShell'i **Yönetici olarak çalıştırın**.

