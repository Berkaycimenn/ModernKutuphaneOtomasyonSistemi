USE [KutuphaneDB]
GO

/****** Object:  Table [dbo].[Odalar]    Script Date: 17.12.2025 22:42:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Odalar](
	[OdaID] [int] IDENTITY(1,1) NOT NULL,
	[KatID] [int] NULL,
	[OdaTipi] [nvarchar](50) NULL,
	[Kapasite] [int] NULL,
	[Musait] [bit] NULL,
	[OdaAdi] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[OdaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Odalar] ADD  DEFAULT ((1)) FOR [Musait]
GO

ALTER TABLE [dbo].[Odalar]  WITH CHECK ADD FOREIGN KEY([KatID])
REFERENCES [dbo].[Katlar] ([KatID])
GO

