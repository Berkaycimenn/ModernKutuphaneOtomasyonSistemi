USE [KutuphaneDB]
GO

/****** Object:  Table [dbo].[Cezalar]    Script Date: 17.12.2025 22:39:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Cezalar](
	[CezaID] [int] IDENTITY(1,1) NOT NULL,
	[KullaniciID] [int] NULL,
	[CezaTutari] [decimal](10, 2) NULL,
	[Odendi] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[CezaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Cezalar] ADD  DEFAULT ((0)) FOR [Odendi]
GO

