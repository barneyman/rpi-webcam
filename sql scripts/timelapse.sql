USE [timelapse]
GO
/****** Object:  User [poster]    Script Date: 29/06/2015 8:16:26 PM ******/
CREATE USER [poster] FOR LOGIN [poster] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  StoredProcedure [dbo].[addPicture]    Script Date: 29/06/2015 8:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[addPicture]
	@hostname nvarchar(50),
	@pic image= null,
	@timeCaptured datetime=null
AS

	declare @entryid as uniqueidentifier
	set @entryid=newid()

	begin transaction

	insert into entries (id,hostname, timeCaptured, timeUploaded) VALUES(@entryid, @hostname, @timeCaptured,GETUTCDATE())

	insert pics ([entry], [pic])  VALUES(@entryid,@pic)

	commit transaction


RETURN 0

GO
/****** Object:  StoredProcedure [dbo].[getLatestPic]    Script Date: 29/06/2015 8:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getLatestPic]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	select top(1) timeCaptured as picDate, pic, datalength(pic) as picLength from entries inner join pics on pics.[entry]=entries.id order by timeCaptured desc


END

GO
/****** Object:  StoredProcedure [dbo].[getPicRange]    Script Date: 29/06/2015 8:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getPicRange]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select timeCaptured as picDate, pic, datalength(pic) as picLength from entries inner join pics on pics.[entry]=entries.id order by timeCaptured asc
END

GO
/****** Object:  StoredProcedure [dbo].[killall]    Script Date: 29/06/2015 8:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[killall]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	delete from pics
	delete from entries

END

GO
/****** Object:  Table [dbo].[entries]    Script Date: 29/06/2015 8:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[entries](
	[id] [uniqueidentifier] NOT NULL,
	[timeCaptured] [datetime] NULL,
	[timeUploaded] [datetime] NOT NULL,
	[hostName] [nvarchar](50) NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[pics]    Script Date: 29/06/2015 8:16:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pics](
	[id] [uniqueidentifier] NOT NULL,
	[entry] [uniqueidentifier] NOT NULL,
	[pic] [image] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
ALTER TABLE [dbo].[pics] ADD  CONSTRAINT [DF_pics_id]  DEFAULT (newid()) FOR [id]
GO
