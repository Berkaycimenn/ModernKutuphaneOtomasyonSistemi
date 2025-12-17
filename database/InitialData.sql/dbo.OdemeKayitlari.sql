USE [KutuphaneDB]
GO

/****** Object:  Table [dbo].[OdemeKayitlari]    Script Date: 17.12.2025 22:42:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[OdemeKayitlari](
	[OdemeID] [int] IDENTITY(1,1) NOT NULL,
	[KullaniciID] [int] NOT NULL,
	[OdemeTuru] [nvarchar](50) NOT NULL,
	[OdemeTutari] [decimal](10, 2) NOT NULL,
	[OdemeTarihi] [datetime] NULL,
	[OdemeYontemi] [nvarchar](50) NULL,
	[KampanyaID] [int] NULL,
	[Aciklama] [nvarchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[OdemeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[OdemeKayitlari] ADD  DEFAULT (getdate()) FOR [OdemeTarihi]
GO

ALTER TABLE [dbo].[OdemeKayitlari]  WITH CHECK ADD FOREIGN KEY([KampanyaID])
REFERENCES [dbo].[Kampanyalar] ([KampanyaID])
GO

ALTER TABLE [dbo].[OdemeKayitlari]  WITH CHECK ADD FOREIGN KEY([KullaniciID])
REFERENCES [dbo].[Kullanicilar] ([KullaniciID])
GO

