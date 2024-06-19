# Project Quản Lý Cây Xăng
## Mô tả bài toán quản lý:
Cây xăng là một trong những điểm cung cấp nhiên liệu thiết yếu cho các phương tiện giao thông. Việc quản lý cây xăng đòi hỏi sự chính xác và kịp thời trong việc nhập và xuất nhiên liệu, đồng thời cần theo dõi lượng nhiên liệu tồn kho, doanh thu và các giao dịch khác. Bài tập này sẽ sử dụng ngôn ngữ SQL để quản lý việc nhập - xuất nhiên liệu, các giao dịch bán hàng và báo cáo hoạt động kinh doanh của cây xăng.
## Những chức năng xây dựng để quản lý cây xăng:
1. Quản lý nhiên liệu:
   - Thêm, sửa đổi, xoá nhiên liệu
   - Tìm kiếm, lọc nhiên liệu theo các tiêu chí của người dùng
   - Xem thông tin chi tiết từng loại nhiên liệu
   - Xem số lượng tồn kho của mỗi loại nhiên liệu
2. Quản lý kho:
   - Cập nhật số lượng nhiên liệu khi có giao dịch nhập hoặc xuất
   - Xem số lượng và thống kê nhiên liệu tồn kho
3. Báo cáo:
   - Báo cáo doanh thu theo ngày, theo tháng
   - Báo cáo tình trạng tồn kho, số lượng nhiên liệu bán chạy nhất
## Nhập xuất và báo cáo các thông tin liên quan đến kho và việc bán hàng:
1. Nhập nhiên liệu:
   - Quản lý việc nhập nhiên liệu từ nhà cung cấp vào kho
   - Ghi nhận thông tin về loại nhiên liệu, số lượng, giá cả và nhà cung cấp
   - Cập nhật lại số lượng tồn kho sau mỗi lần nhập nhiên liệu
2. Xuất nhiên liệu:
   - Quản lý việc xuất nhiên liệu từ kho để bán cho khách hàng
   - Ghi nhận thông tin về loại nhiên liệu, số lượng, giá cả và thông tin khách hàng
   - Cập nhật tồn kho sau mỗi lần xuất nhiên liệu
3. Báo cáo:
   - Báo cáo doanh thu theo ngày, tháng giúp quản lý được lợi nhuận
   - Tạo và xem báo cáo hoạt động kinh doanh của cây xăng, số lượng nhiên liệu tồn kho nhiều nhất, số lượng nhiên liệu bán chạy nhất
## Các bảng dữ liệu cần thiết:
1. Bảng Nhiên Liệu:
   - Mã nhiên liệu (PK), tên nhiên liệu, đơn giá, số lượng còn lại, mã nhà cung cấp (FK)
2. Bảng Khách Hàng:
   - Mã khách hàng (PK), tên khách hàng, số điện thoại, địa chỉ
3. Bảng Đơn Hàng:
   - Mã đơn hàng (PK), mã khách hàng (FK), ngày đặt hàng, tổng tiền
4. Bảng Chi Tiết Đơn Hàng:
   - Mã chi tiết đơn hàng (PK), mã đơn hàng (FK), mã nhiên liệu (FK), số lượng, giá
5. Bảng Nhà Cung Cấp:
   - Mã nhà cung cấp (PK), tên nhà cung cấp, tên người liên hệ, số điện thoại người liên hệ, địa chỉ
6. Bảng Giao Dịch Kho:
   - Mã giao dịch (PK), mã nhiên liệu (FK), số lượng, ngày giao dịch, loại giao dịch (nhập/xuất), mã nhà cung cấp (FK nếu là nhập)

## Tạo các bảng trong SQL Server:
-- Bảng Nhiên Liệu
CREATE TABLE NhienLieu (
    MaNhienLieu NVARCHAR(50) PRIMARY KEY,
    TenNhienLieu NVARCHAR(100),
    DonGia DECIMAL(18, 2),
    SoLuongConLai INT,
    MaNhaCungCap NVARCHAR(50),
    FOREIGN KEY (MaNhaCungCap) REFERENCES NhaCungCap(MaNhaCungCap)
);

-- Bảng Khách Hàng
CREATE TABLE KhachHang (
    MaKhachHang NVARCHAR(50) PRIMARY KEY,
    TenKhachHang NVARCHAR(100),
    SoDienThoai NVARCHAR(15),
    DiaChi NVARCHAR(200)
);

-- Bảng Đơn Hàng
CREATE TABLE DonHang (
    MaDonHang NVARCHAR(50) PRIMARY KEY,
    MaKhachHang NVARCHAR(50),
    NgayDat DATE,
    TongTien DECIMAL(18, 2),
    FOREIGN KEY (MaKhachHang) REFERENCES KhachHang(MaKhachHang)
);

-- Bảng Chi Tiết Đơn Hàng
CREATE TABLE ChiTietDonHang (
    MaChiTietDonHang NVARCHAR(50) PRIMARY KEY,
    MaDonHang NVARCHAR(50),
    MaNhienLieu NVARCHAR(50),
    SoLuong INT,
    Gia DECIMAL(18, 2),
    FOREIGN KEY (MaDonHang) REFERENCES DonHang(MaDonHang),
    FOREIGN KEY (MaNhienLieu) REFERENCES NhienLieu(MaNhienLieu)
);

-- Bảng Nhà Cung Cấp
CREATE TABLE NhaCungCap (
    MaNhaCungCap NVARCHAR(50) PRIMARY KEY,
    TenNhaCungCap NVARCHAR(100),
    TenNguoiLienHe NVARCHAR(100),
    SoDienThoai NVARCHAR(15),
    DiaChi NVARCHAR(200)
);

-- Bảng Giao Dịch Kho
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

## Tạo Stored Procedures (SP) cho các chức năng:
1. Thêm nhiên liệu:
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

2. Xóa nhiên liệu:
CREATE PROCEDURE SP_xoaNhienLieu
    @MaNhienLieu NVARCHAR(50)
AS
BEGIN
    DELETE FROM NhienLieu WHERE MaNhienLieu = @MaNhienLieu;
END;

3. Cập nhật nhiên liệu:
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

4. Tìm kiếm nhiên liệu:
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

5. Xem thông tin chi tiết nhiên liệu:
CREATE PROCEDURE SP_xemChiTietNhienLieu
    @MaNhienLieu NVARCHAR(50)
AS
BEGIN
    SELECT * FROM NhienLieu WHERE MaNhienLieu = @MaNhienLieu;
END;

6. Báo cáo doanh thu:
CREATE PROCEDURE SP_baoCaoDoanhThu
    @NgayBatDau DATE,
    @NgayKetThuc DATE
AS
BEGIN
    SELECT MaDonHang, NgayDat, TongTien
    FROM DonHang
    WHERE NgayDat BETWEEN @NgayBatDau AND @NgayKetThuc;
END;

## Tạo các Function (FN) hỗ trợ:
Tính tổng doanh thu trong khoảng thời gian:
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
Tính tổng số lượng nhiên liệu còn lại trong kho:
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
Kiểm tra tồn kho tối thiểu:
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
Kiểm tra tính hợp lệ của mã khách hàng:
CREATE FUNCTION FN_kiemTraMaKhachHang
    (@MaKhachHang NVARCHAR(50))
RETURNS BIT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM KhachHang WHERE MaKhachHang = @MaKhachHang)
        RETURN 1;
    RETURN 0;
END;
Kiểm tra tính hợp lệ của mã nhiên liệu:
CREATE FUNCTION FN_kiemTraMaNhienLieu
    (@MaNhienLieu NVARCHAR(50))
RETURNS BIT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM NhienLieu WHERE MaNhienLieu = @MaNhienLieu)
        RETURN 1;
    RETURN 0;
END;

## Thêm dữ liệu mẫu vào các bảng:
1. Thêm dữ liệu vào bảng NhienLieu:
INSERT INTO NhienLieu (MaNhienLieu, TenNhienLieu, DonGia, SoLuongConLai, MaNhaCungCap) VALUES
('NL1', 'Xăng RON 95', 21000, 10000, 'NCC1'),
('NL2', 'Xăng RON 92', 20000, 8000, 'NCC1'),
('NL3', 'Dầu Diesel', 15000, 5000, 'NCC2');

2. Thêm dữ liệu vào bảng KhachHang:
INSERT INTO KhachHang (MaKhachHang, TenKhachHang, SoDienThoai, DiaChi) VALUES
('KH1', 'Nguyen Van A', '0912345678', '123 Phan Dinh Phung, Hanoi'),
('KH2', 'Tran Thi B', '0987654321', '456 Hai Ba Trung, Ho Chi Minh');


3. Thêm dữ liệu vào bảng DonHang và ChiTietDonHang:
INSERT INTO DonHang (MaDonHang, MaKhachHang, NgayDat, TongTien) VALUES
('DH1', 'KH1', '2024-06-01', 2100000),
('DH2', 'KH2', '2024-06-02', 3000000);

INSERT INTO ChiTietDonHang (MaChiTietDonHang, MaDonHang, MaNhienLieu, SoLuong, Gia) VALUES
('CTDH1', 'DH1', 'NL1', 100, 21000),
('CTDH2', 'DH2', 'NL2', 150, 20000);

4. Thêm dữ liệu vào bảng NhaCungCap:
INSERT INTO NhaCungCap (MaNhaCungCap, TenNhaCungCap, TenNguoiLienHe, SoDienThoai, DiaChi) VALUES
('NCC1', 'Cong Ty A', 'Nguyen Van C', '0912345678', '789 Le Duan, Da Nang'),
('NCC2', 'Cong Ty B', 'Tran Thi D', '0987654321', '101 Nguyen Trai, Hue');

5. Thêm dữ liệu vào bảng GiaoDichKho:
INSERT INTO GiaoDichKho (MaGiaoDich, MaNhienLieu, SoLuong, NgayGiaoDich, LoaiGiaoDich, MaNhaCungCap) VALUES
('GD1', 'NL1', 10000, '2024-06-01', 'nhap', 'NCC1'),
('GD2', 'NL2', 8000, '2024-06-02', 'nhap', 'NCC1'),
('GD3', 'NL1', 100, '2024-06-01', 'xuat', 'NCC1');

## Kết luận
Trên đây là các bước cần thiết để xây dựng hệ thống quản lý cây xăng sử dụng SQL. Hệ thống này cho phép người dùng quản lý nhiên liệu, khách hàng, đơn hàng, và các giao dịch kho, đồng thời cung cấp các báo cáo doanh thu giúp cây xăng hoạt động hiệu quả hơn.
