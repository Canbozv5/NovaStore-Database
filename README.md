# NovaStore E-Ticaret Veri Yönetim Sistemi

Bu proje, bir e-ticaret platformunun veri tabanı mimarisini tasarlamak ve karmaşık veri analizleri gerçekleştirmek amacıyla SQL Server (T-SQL) kullanılarak geliştirilmiştir.

## Özellikler
- **İlişkisel Veri Modeli:** Categories, Products, Customers ve Orders tabloları arasında Foreign Key bağımlılıkları ile optimize edilmiş yapı.
- **Gelişmiş Sorgular:** JOIN operasyonları, GROUP BY ile kategori bazlı analizler ve müşteri harcama raporları.
- **Veri Güvenliği & Hız:** Dinamik VIEW yapıları ile soyutlanmış sorgu katmanı.

## Veri Modeli (ERD)
Proje şu ana tabloları içerir:
- `Categories`: Ürün kategorileri.
- `Products`: Ürün detayları ve stok takibi.
- `Customers`: Müşteri bilgileri.
- `Orders` & `OrderDetails`: Sipariş geçmişi ve detay analizi.

## Örnek Analiz Sorgusu
Aşağıdaki sorgu, en çok harcama yapan müşterileri ciro bazlı listeler:
```sql
SELECT Customers.FullName, SUM(Orders.TotalAmount) AS TotalSpent
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.FullName
ORDER BY TotalSpent DESC;
