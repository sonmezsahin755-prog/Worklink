# Backend Dev Server Başlatma Scripti
Write-Host "Backend Dev Server Başlatılıyor..." -ForegroundColor Cyan

# Backend klasörüne git
Set-Location "$PSScriptRoot"

# .env dosyası kontrolü
if (-not (Test-Path .env)) {
    Write-Host ".env dosyası bulunamadı, env.example'dan oluşturuluyor..." -ForegroundColor Yellow
    Copy-Item env.example .env
}

# PostgreSQL servis kontrolü
Write-Host "`nPostgreSQL servisi kontrol ediliyor..." -ForegroundColor Cyan
$pgService = Get-Service | Where-Object { $_.Name -like "*postgres*" -or $_.DisplayName -like "*PostgreSQL*" } | Select-Object -First 1

if ($pgService) {
    if ($pgService.Status -ne "Running") {
        Write-Host "PostgreSQL servisi durdurulmuş. Başlatılıyor..." -ForegroundColor Yellow
        try {
            Start-Service -Name $pgService.Name -ErrorAction Stop
            Write-Host "PostgreSQL servisi başlatıldı." -ForegroundColor Green
            Start-Sleep -Seconds 3
        } catch {
            Write-Host "`n⚠️  PostgreSQL servisi başlatılamadı (Yönetici yetkisi gerekli)" -ForegroundColor Red
            Write-Host "`nLütfen şu adımlardan birini uygulayın:`n" -ForegroundColor Yellow
            Write-Host "1. PowerShell'i YÖNETİCİ OLARAK açın ve şunu çalıştırın:" -ForegroundColor Cyan
            Write-Host "   net start $($pgService.Name)" -ForegroundColor White
            Write-Host "`n2. VEYA Windows Services üzerinden:" -ForegroundColor Cyan
            Write-Host "   - Windows + R tuşlarına basın" -ForegroundColor White
            Write-Host "   - 'services.msc' yazın ve Enter'a basın" -ForegroundColor White
            Write-Host "   - 'postgresql-x64-14' servisini bulun ve Başlat'ı tıklayın`n" -ForegroundColor White
            Write-Host "PostgreSQL'i başlattıktan sonra tekrar 'npm run dev' çalıştırın.`n" -ForegroundColor Yellow
            exit 1
        }
    } else {
        Write-Host "PostgreSQL servisi çalışıyor." -ForegroundColor Green
    }
} else {
    Write-Host "PostgreSQL servisi bulunamadı. Lütfen PostgreSQL'in kurulu olduğundan emin olun." -ForegroundColor Yellow
    Write-Host "Devam ediliyor..." -ForegroundColor Yellow
}

# Node modules kontrolü
if (-not (Test-Path node_modules)) {
    Write-Host "`nnode_modules bulunamadı, npm install çalıştırılıyor..." -ForegroundColor Yellow
    npm install
}

# Dev server'ı başlat
Write-Host "`nDev server başlatılıyor..." -ForegroundColor Cyan
Write-Host "Çıkmak için Ctrl+C basın`n" -ForegroundColor Gray

npm run dev

