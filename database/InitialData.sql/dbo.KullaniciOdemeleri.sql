USE [KutuphaneDB]
GO

/****** Object:  Table [dbo].[KullaniciOdemeleri]    Script Date: 17.12.2025 22:41:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[KullaniciOdemeleri](
	[OdemeID] [int] IDENTITY(1,1) NOT NULL,
	[KullaniciID] [int] NULL,
	[Tarih] [date] NULL,
	[Ucret] [decimal](10, 2) NOT NULL,
	[Aciklama] [nvarchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[OdemeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[KullaniciOdemeleri] ADD  DEFAULT (getdate()) FOR [Tarih]
GO

ALTER TABLE [dbo].[KullaniciOdemeleri]  WITH CHECK ADD FOREIGN KEY([KullaniciID])
REFERENCES [dbo].[Kullanicilar] ([KullaniciID])
GO

