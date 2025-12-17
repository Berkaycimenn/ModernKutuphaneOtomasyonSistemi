USE [KutuphaneDB]
GO

/****** Object:  Table [dbo].[SiparisDetaylari]    Script Date: 17.12.2025 22:44:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SiparisDetaylari](
	[DetayID] [int] IDENTITY(1,1) NOT NULL,
	[SiparisID] [int] NULL,
	[UrunID] [int] NULL,
	[Adet] [int] NOT NULL,
	[Fiyat] [decimal](10, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DetayID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[SiparisDetaylari]  WITH CHECK ADD FOREIGN KEY([SiparisID])
REFERENCES [dbo].[Siparisler] ([SiparisID])
GO

ALTER TABLE [dbo].[SiparisDetaylari]  WITH CHECK ADD FOREIGN KEY([UrunID])
REFERENCES [dbo].[KafeUrunleri] ([UrunID])
GO

ALTER TABLE [dbo].[SiparisDetaylari]  WITH CHECK ADD  CONSTRAINT [CHK_SiparisDetaylari_Adet_Positive] CHECK  (([Adet]>(0)))
GO

ALTER TABLE [dbo].[SiparisDetaylari] CHECK CONSTRAINT [CHK_SiparisDetaylari_Adet_Positive]
GO

