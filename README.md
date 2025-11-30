# Kurumsal Backend API

Express + TypeScript + PostgreSQL backend API for the Kurumsal Platform.

## Özellikler

- ✅ Express 4 + TypeScript 5 + ES Modules
- ✅ Katmanlı mimari: `routes → controllers → services → database`
- ✅ Zod ile request validation
- ✅ JWT authentication (access + refresh tokens)
- ✅ PostgreSQL veritabanı şeması
- ✅ bcrypt ile şifre hashleme
- ✅ Session yönetimi (refresh token veritabanında saklanır)
- ✅ Audit log sistemi
- ✅ Authentication middleware
- ✅ Role-based access control (RBAC) hazırlığı

## Kurulum

```bash
cd backend
npm install
cp env.example .env  # Windows için: copy env.example .env
```

`.env` dosyasını düzenleyin:

```env
NODE_ENV=development
PORT=4000
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/kurumsal
JWT_SECRET=your-super-secret-jwt-key-min-16-chars
LOG_LEVEL=debug
```

## Veritabanı Kurulumu

1. PostgreSQL'in çalıştığından emin olun
2. Veritabanını oluşturun:

```sql
CREATE DATABASE kurumsal;
```

3. Migration'ları çalıştırın:

```bash
npm run migrate
```

4. Seed kullanıcıların şifrelerini hash'leyin:

```bash
npm run hash-passwords
```

Bu komut tüm seed kullanıcıların şifresini `demo1234` olarak ayarlar (hash'lenir).

## Demo Kullanıcılar

Migration sonrası şu kullanıcılar oluşturulur:

| Rol | Identifier | Şifre | Açıklama |
|-----|-----------|-------|----------|
| firma | admin@demo.com | demo1234 | Firma Yöneticisi |
| taseron | taseron01 | demo1234 | Taşeron Firma Yetkilisi |
| personel | EMP001 | demo1234 | Saha Personeli |

## Geliştirme

```bash
npm run dev      # tsx ile hot-reload
npm run build    # TypeScript derleme
npm start        # dist/server.js ile çalıştırma
npm run lint     # ESLint kontrolü
```

## API Endpoints

### Authentication

- `POST /api/v1/auth/login` - Rol bazlı giriş
  ```json
  {
    "role": "firma" | "taseron" | "personel",
    "identifier": "admin@demo.com",
    "password": "demo1234"
  }
  ```

- `POST /api/v1/auth/refresh` - Refresh token ile yeni access token
  ```json
  {
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
  ```

- `POST /api/v1/auth/logout` - Çıkış yap (refresh token'ı iptal et)

### Profile

- `GET /api/v1/profile/me` - Aktif kullanıcının profili (Auth gerekli)
  ```
  Authorization: Bearer <access_token>
  ```

### Health

- `GET /api/v1/health` - API sağlık kontrolü

## Veritabanı Şeması

- `tenants` - Organizasyonlar/Firmalar
- `users` - Kullanıcılar (firma/taseron/personel)
- `user_credentials` - Şifreler ve MFA bilgileri
- `sessions` - Refresh token kayıtları
- `audit_logs` - Tüm kritik işlem logları

## Güvenlik

- Helmet.js ile HTTP header güvenliği
- CORS yapılandırması
- JWT token doğrulama
- bcrypt ile şifre hashleme (salt rounds: 10)
- Refresh token hash'lenerek veritabanında saklanır
- IP adresi ve User-Agent loglama
- Audit log sistemi

## Sonraki Adımlar

1. ✅ Veritabanı şeması ve migration'lar
2. ✅ Auth servisi ve gerçek DB sorguları
3. ✅ Session yönetimi
4. 🔄 Rate limiting middleware
5. 🔄 RBAC middleware tam implementasyonu
6. 🔄 Firma ve personel modülleri
7. 🔄 Dashboard endpoint'leri
8. 🔄 Webhook ve API key yönetimi

## Notlar

- Production ortamında `JWT_SECRET` mutlaka güçlü ve random olmalı
- Refresh token'lar 7 gün, access token'lar 15 dakika geçerli
- Tüm login/logout işlemleri audit_logs tablosuna kaydedilir
