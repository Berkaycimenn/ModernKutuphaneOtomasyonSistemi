USE [KutuphaneDB]
GO

/****** Object:  Table [dbo].[OdaRezervasyonlari]    Script Date: 17.12.2025 22:42:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[OdaRezervasyonlari](
	[RezervasyonID] [int] IDENTITY(1,1) NOT NULL,
	[OdaID] [int] NOT NULL,
	[KullaniciID] [int] NOT NULL,
	[BaslangicTarihi] [datetime] NOT NULL,
	[BitisTarihi] [datetime] NOT NULL,
	[Durum] [nvarchar](20) NULL,
	[Aciklama] [nvarchar](255) NULL,
	[OlusturmaTarihi] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[RezervasyonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[OdaRezervasyonlari] ADD  DEFAULT ('Aktif') FOR [Durum]
GO

ALTER TABLE [dbo].[OdaRezervasyonlari] ADD  DEFAULT (getdate()) FOR [OlusturmaTarihi]
GO

ALTER TABLE [dbo].[OdaRezervasyonlari]  WITH CHECK ADD  CONSTRAINT [FK_Rezervasyon_Oda] FOREIGN KEY([OdaID])
REFERENCES [dbo].[Odalar] ([OdaID])
GO

ALTER TABLE [dbo].[OdaRezervasyonlari] CHECK CONSTRAINT [FK_Rezervasyon_Oda]
GO

