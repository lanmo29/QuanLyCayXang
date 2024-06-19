CREATE DATABASE [QuanLyCayXang];
USE [QuanLyCayXang];

-- Tạo bảng
CREATE TABLE NhaCungCap (
    MaNhaCungCap NVARCHAR(50) PRIMARY KEY,
    TenNhaCungCap NVARCHAR(100),
    TenNguoiLienHe NVARCHAR(100),
    SoDienThoai NVARCHAR(15),
    DiaChi NVARCHAR(200)
);
CREATE TABLE KhachHang (
    MaKhachHang NVARCHAR(50) PRIMARY KEY,
    TenKhachHang NVARCHAR(100),
    SoDienThoai NVARCHAR(15),
    DiaChi NVARCHAR(200)
);
CREATE TABLE NhienLieu (
    MaNhienLieu NVARCHAR(50) PRIMARY KEY,
    TenNhienLieu NVARCHAR(100),
    DonGia DECIMAL(18, 2),
    SoLuongConLai INT,
    MaNhaCungCap NVARCHAR(50),
    FOREIGN KEY (MaNhaCungCap) REFERENCES NhaCungCap(MaNhaCungCap)
);
CREATE TABLE DonHang (
    MaDonHang NVARCHAR(50) PRIMARY KEY,
    MaKhachHang NVARCHAR(50),
    NgayDat DATE,
    TongTien DECIMAL(18, 2),
    FOREIGN KEY (MaKhachHang) REFERENCES KhachHang(MaKhachHang)
);
CREATE TABLE ChiTietDonHang (
    MaChiTietDonHang NVARCHAR(50) PRIMARY KEY,
    MaDonHang NVARCHAR(50),
    MaNhienLieu NVARCHAR(50),
    SoLuong INT,
    Gia DECIMAL(18, 2),
    FOREIGN KEY (MaDonHang) REFERENCES DonHang(MaDonHang),
    FOREIGN KEY (MaNhienLieu) REFERENCES NhienLieu(MaNhienLieu)
);
CREATE TABLE GiaoDichKho (
    MaGiaoDich NVARCHAR(50) PRIMARY KEY,
    MaNhienLieu NVARCHAR(50),
    SoLuong INT,
    NgayGiaoDich DATE,
    LoaiGiaoDich NVARCHAR(50),
    MaNhaCungCap NVARCHAR(50),
    FOREIGN KEY (MaNhienLieu) REFERENCES NhienLieu(MaNhienLieu),
    FOREIGN KEY (MaNhaCungCap) REFERENCES NhaCungCap(MaNhaCungCap)
);
GO
-- Stored Procedure
CREATE PROCEDURE SP_themNhienLieu
    @MaNhienLieu NVARCHAR(50),
    @TenNhienLieu NVARCHAR(100),
    @DonGia DECIMAL(18, 2),
    @SoLuongConLai INT,
    @MaNhaCungCap NVARCHAR(50)
AS
BEGIN
    INSERT INTO NhienLieu (MaNhienLieu, TenNhienLieu, DonGia, SoLuongConLai, MaNhaCungCap)
    VALUES (@MaNhienLieu, @TenNhienLieu, @DonGia, @SoLuongConLai, @MaNhaCungCap);
END;
GO

CREATE PROCEDURE SP_xoaNhienLieu
    @MaNhienLieu NVARCHAR(50)
AS
BEGIN
    DELETE FROM NhienLieu WHERE MaNhienLieu = @MaNhienLieu;
END;
GO

CREATE PROCEDURE SP_capNhatNhienLieu
    @MaNhienLieu NVARCHAR(50),
    @TenNhienLieu NVARCHAR(100),
    @DonGia DECIMAL(18, 2),
    @SoLuongConLai INT,
    @MaNhaCungCap NVARCHAR(50)
AS
BEGIN
    UPDATE NhienLieu
    SET TenNhienLieu = @TenNhienLieu, DonGia = @DonGia, SoLuongConLai = @SoLuongConLai, MaNhaCungCap = @MaNhaCungCap
    WHERE MaNhienLieu = @MaNhienLieu;
END;
GO

CREATE PROCEDURE SP_timKiemNhienLieu
    @MaNhienLieu NVARCHAR(50) = NULL,
    @TenNhienLieu NVARCHAR(100) = NULL,
    @MaNhaCungCap NVARCHAR(50) = NULL
AS
BEGIN
    SELECT * FROM NhienLieu
    WHERE (MaNhienLieu = ISNULL(@MaNhienLieu, MaNhienLieu))
    AND (TenNhienLieu LIKE '%' + ISNULL(@TenNhienLieu, '') + '%')
    AND (MaNhaCungCap = ISNULL(@MaNhaCungCap, MaNhaCungCap));
END;
GO

CREATE PROCEDURE SP_xemChiTietNhienLieu
    @MaNhienLieu NVARCHAR(50)
AS
BEGIN
    SELECT * FROM NhienLieu WHERE MaNhienLieu = @MaNhienLieu;
END;
GO

CREATE PROCEDURE SP_baoCaoDoanhThu
    @NgayBatDau DATE,
    @NgayKetThuc DATE
AS
BEGIN
    SELECT MaDonHang, NgayDat, TongTien
    FROM DonHang
    WHERE NgayDat BETWEEN @NgayBatDau AND @NgayKetThuc;
END;
GO

-- Function
CREATE FUNCTION FN_tongDoanhThu
    (@NgayBatDau DATE, @NgayKetThuc DATE)
RETURNS DECIMAL(18, 2)
AS
BEGIN
    DECLARE @TongTien DECIMAL(18, 2);
    SELECT @TongTien = SUM(TongTien)
    FROM DonHang
    WHERE NgayDat BETWEEN @NgayBatDau AND @NgayKetThuc;
    RETURN @TongTien;
END;
GO

CREATE FUNCTION FN_tongSoLuongNhienLieu
    (@MaNhienLieu NVARCHAR(50))
RETURNS INT
AS
BEGIN
    DECLARE @TongSoLuong INT;
    SELECT @TongSoLuong = SUM(SoLuong)
    FROM GiaoDichKho
    WHERE MaNhienLieu = @MaNhienLieu AND LoaiGiaoDich = 'nhap'
    GROUP BY MaNhienLieu;

    DECLARE @SoLuongDaBan INT;
    SELECT @SoLuongDaBan = SUM(SoLuong)
    FROM ChiTietDonHang
    WHERE MaNhienLieu = @MaNhienLieu
    GROUP BY MaNhienLieu;

    RETURN @TongSoLuong - @SoLuongDaBan;
END;
GO

CREATE FUNCTION FN_kiemTraTonKhoToiThieu
    (@MaNhienLieu NVARCHAR(50), @SoLuongToiThieu INT)
RETURNS BIT
AS
BEGIN
    DECLARE @SoLuongConLai INT;
    SELECT @SoLuongConLai = SoLuongConLai FROM NhienLieu WHERE MaNhienLieu = @MaNhienLieu;
    IF @SoLuongConLai < @SoLuongToiThieu
        RETURN 1;
    RETURN 0;
END;
GO

CREATE FUNCTION FN_kiemTraMaKhachHang
    (@MaKhachHang NVARCHAR(50))
RETURNS BIT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM KhachHang WHERE MaKhachHang = @MaKhachHang)
        RETURN 1;
    RETURN 0;
END;
GO

CREATE FUNCTION FN_kiemTraMaNhienLieu
    (@MaNhienLieu NVARCHAR(50))
RETURNS BIT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM NhienLieu WHERE MaNhienLieu = @MaNhienLieu)
        RETURN 1;
    RETURN 0;
END;
GO

-- Thêm DATA
INSERT INTO NhienLieu (MaNhienLieu, TenNhienLieu, DonGia, SoLuongConLai, MaNhaCungCap) VALUES
('NL1', 'Xăng RON 95', 21000, 10000, 'NCC1'),
('NL2', 'Xăng RON 92', 20000, 8000, 'NCC1'),
('NL3', 'Dầu Diesel', 15000, 5000, 'NCC2');
GO

INSERT INTO KhachHang (MaKhachHang, TenKhachHang, SoDienThoai, DiaChi) VALUES
('KH1', 'Nguyen Van A', '0912345678', '123 Phan Dinh Phung, Hanoi'),
('KH2', 'Tran Thi B', '0987654321', '456 Hai Ba Trung, Ho Chi Minh');
GO
INSERT INTO DonHang (MaDonHang, MaKhachHang, NgayDat, TongTien) VALUES
('DH1', 'KH1', '2024-06-01', 2100000),
('DH2', 'KH2', '2024-06-02', 3000000);
GO
INSERT INTO ChiTietDonHang (MaChiTietDonHang, MaDonHang, MaNhienLieu, SoLuong, Gia) VALUES
('CTDH1', 'DH1', 'NL1', 100, 21000),
('CTDH2', 'DH2', 'NL2', 150, 20000);
GO

INSERT INTO NhaCungCap (MaNhaCungCap, TenNhaCungCap, TenNguoiLienHe, SoDienThoai, DiaChi) VALUES
('NCC1', 'Cong Ty A', 'Nguyen Van C', '0912345678', '789 Le Duan, Da Nang'),
('NCC2', 'Cong Ty B', 'Tran Thi D', '0987654321', '101 Nguyen Trai, Hue');
GO

INSERT INTO GiaoDichKho (MaGiaoDich, MaNhienLieu, SoLuong, NgayGiaoDich, LoaiGiaoDich, MaNhaCungCap) VALUES
('GD1', 'NL1', 10000, '2024-06-01', 'nhap', 'NCC1'),
('GD2', 'NL2', 8000, '2024-06-02', 'nhap', 'NCC1'),
('GD3', 'NL1', 100, '2024-06-01', 'xuat', 'NCC1');
GO

--TEST
-- Test SP_themNhienLieu
EXEC SP_themNhienLieu 'NL4', 'Xăng sinh học E5', 19000, 6000, 'NCC1';
SELECT * FROM NhienLieu WHERE MaNhienLieu = 'NL4';

-- Test SP_xoaNhienLieu
EXEC SP_xoaNhienLieu 'NL4';
SELECT * FROM NhienLieu WHERE MaNhienLieu = 'NL4';

-- Test SP_capNhatNhienLieu
EXEC SP_capNhatNhienLieu 'NL1', 'Xăng RON 95', 22000, 9000, 'NCC1';
SELECT * FROM NhienLieu WHERE MaNhienLieu = 'NL1';

-- Test SP_timKiemNhienLieu
EXEC SP_timKiemNhienLieu NULL, 'Xăng', NULL;
EXEC SP_timKiemNhienLieu 'NL1', NULL, NULL;
EXEC SP_timKiemNhienLieu NULL, NULL, 'NCC1';

-- Test SP_xemChiTietNhienLieu
EXEC SP_xemChiTietNhienLieu 'NL1';

-- Test SP_baoCaoDoanhThu
EXEC SP_baoCaoDoanhThu '2024-06-01', '2024-06-30';

-- Test FN_tongDoanhThu
SELECT dbo.FN_tongDoanhThu('2024-06-01', '2024-06-30') AS TongDoanhThu;

-- Test FN_tongSoLuongNhienLieu
SELECT dbo.FN_tongSoLuongNhienLieu('NL1') AS TongSoLuongNhienLieu;

-- Test FN_kiemTraTonKhoToiThieu
SELECT dbo.FN_kiemTraTonKhoToiThieu('NL1', 5000) AS TonKhoToiThieu;

-- Test FN_kiemTraMaKhachHang
SELECT dbo.FN_kiemTraMaKhachHang('KH1') AS MaKhachHangHopLe;
SELECT dbo.FN_kiemTraMaKhachHang('KH99') AS MaKhachHangHopLe;

-- Test FN_kiemTraMaNhienLieu
SELECT dbo.FN_kiemTraMaNhienLieu('NL1') AS MaNhienLieuHopLe;
SELECT dbo.FN_kiemTraMaNhienLieu('NL99') AS MaNhienLieuHopLe;
