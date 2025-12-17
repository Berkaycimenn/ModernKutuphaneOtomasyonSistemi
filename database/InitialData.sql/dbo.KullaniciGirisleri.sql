USE [KutuphaneDB]
GO

/****** Object:  Table [dbo].[KullaniciGirisleri]    Script Date: 17.12.2025 22:40:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[KullaniciGirisleri](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[KullaniciID] [int] NOT NULL,
	[Basarili] [bit] NOT NULL,
	[IPAdres] [nvarchar](50) NULL,
	[Tarih] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[KullaniciGirisleri] ADD  DEFAULT (getdate()) FOR [Tarih]
GO

ALTER TABLE [dbo].[KullaniciGirisleri]  WITH CHECK ADD FOREIGN KEY([KullaniciID])
REFERENCES [dbo].[Kullanicilar] ([KullaniciID])
GO

