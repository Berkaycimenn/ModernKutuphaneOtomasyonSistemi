USE [KutuphaneDB]
GO

/****** Object:  Table [dbo].[Loglar]    Script Date: 17.12.2025 22:41:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Loglar](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[KullaniciID] [int] NULL,
	[IslemTipi] [nvarchar](50) NOT NULL,
	[Aciklama] [nvarchar](255) NULL,
	[Tarih] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Loglar] ADD  DEFAULT (getdate()) FOR [Tarih]
GO

ALTER TABLE [dbo].[Loglar]  WITH CHECK ADD FOREIGN KEY([KullaniciID])
REFERENCES [dbo].[Kullanicilar] ([KullaniciID])
GO

