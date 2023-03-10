USE [MiVet]
GO
/****** Object:  StoredProcedure [dbo].[ShareStory_Insert]    Script Date: 12/26/2022 14:25:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Joe Medina
-- Create date: 10/27/2022
-- Description:	Insert for dbo.ShareStory
-- Code Reviewer:


-- MODIFIED BY: author
-- MODIFIED DATE: 10/27/2022
-- Code Reviewer: 
-- Note: 
-- =============================================
ALTER proc [dbo].[ShareStory_Insert]
	@batchIds dbo.IdTable READONLY
	,@Name nvarchar(50)
	,@Email nvarchar(50)
	,@Story nvarchar(3000)
	,@UserId int
	,@Id int OUTPUT

AS
/*

DECLARE	@newIds dbo.IdTable
INSERT INTO	@newIds
	(Id)
VALUES
	(10)
	,(11)
	,(12)

DECLARE	@Id int = 0
		,@Name nvarchar(50) = 'Shaq'
		,@Email nvarchar(50) = 'shaq@test.com'
		,@Story nvarchar(3000) = 'The story of shaq'
		,@CreatedBy int = 44

EXECUTE	dbo.ShareStory_Insert
	@newIds
	,@Name
	,@Email
	,@Story
	,@CreatedBy
	,@Id OUTPUT


SELECT	*
FROM	dbo.ShareStoryFile

SELECT	*
FROM	dbo.ShareStory

*/

BEGIN

	INSERT INTO	[dbo].[ShareStory]
		([Name]
		,[Email]
		,[Story]
		,[CreatedBy])
	VALUES
		(@Name
		,@Email
		,@Story
		,@UserId)

	SET	@Id = SCOPE_IDENTITY()


	INSERT INTO dbo.ShareStoryFile
		(fileId
		,storyId)
	SELECT	i.Id
			,@Id
	FROM	@batchIds as i

END
