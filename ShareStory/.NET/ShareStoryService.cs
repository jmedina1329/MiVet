public class ShareStoryService : IShareStoryService
{
    IDataProvider _data = null;

    public ShareStoryService(IDataProvider data)
    {
        _data = data;
    }

    public Paged<Story> GetPaginated(int pageIndex, int pageSize)
    {
        string procName = "[dbo].[ShareStory_SelectAll]";

        Paged<Story> pagedList = null;
        List<Story> list = null;
        int i = 0;
        int totalCount = 0;

        _data.ExecuteCmd(
            procName,
            inputParamMapper: delegate (SqlParameterCollection coll)
            {
                coll.AddWithValue("@PageIndex", pageIndex);
                coll.AddWithValue("@PageSize", pageSize);
            },
            singleRecordMapper: delegate (IDataReader reader, short set)
            {
                Story story = MapSingleStory(reader, ref i);

                if (totalCount == 0)
                {
                    totalCount = reader.GetSafeInt32(i++);
                }
                if (list == null)
                {
                    list = new List<Story>();

                }
                list.Add(story);
            });
        if (list != null)
        {
            pagedList = new Paged<Story>(list, pageIndex, pageSize, totalCount);
        }
        return pagedList;
    }

    public Story GetById(int id)
    {
        string procName = "[dbo].[ShareStory_Select_ById]";

        int i = 0;
        Story story = null;

        _data.ExecuteCmd(
            procName,
            inputParamMapper: delegate (SqlParameterCollection coll)
            {
                coll.AddWithValue("@Id", id);
            },
            singleRecordMapper: delegate (IDataReader reader, short set)
            {
                story = MapSingleStory(reader, ref i);
            });
        return story;
    }

    public int Create(StoryAddRequest model, int userId)
    {
        string procName = "[dbo].[ShareStory_Insert]";
        int id = 0;

        DataTable idsTable = MapFilesToTable(model.FileIds);

        _data.ExecuteNonQuery(
            procName,
            inputParamMapper: delegate (SqlParameterCollection coll)
            {
                AddCommonParams(model, coll);
                coll.AddWithValue("@UserId", userId);
                coll.AddWithValue("@batchIds", idsTable);

                SqlParameter idOut = new SqlParameter("@Id", SqlDbType.Int);
                idOut.Direction = ParameterDirection.Output;

                coll.Add(idOut);
            },
            returnParameters: delegate (SqlParameterCollection returnColl)
            {
                object idObj = returnColl["@Id"].Value;
                int.TryParse(idObj.ToString(), out id);
            });
        return id;
    }

    public void Update(StoryUpdateRequest model, int userId)
    {
        string procName = "[dbo].[ShareStory_Update]";

        DataTable fileIdsTable = MapFilesToTable(model.FileIds);

        _data.ExecuteNonQuery(
            procName,
            inputParamMapper: delegate (SqlParameterCollection coll)
            {
                coll.AddWithValue("@Id", model.Id);
                AddCommonParams(model, coll);
                coll.AddWithValue("@UserId", userId);
                coll.AddWithValue("@batchIds", fileIdsTable);

            },
            returnParameters: null
            );
    }

    public void UpdateApproval(int id, int userId, bool isApproved)
    {
        string procName = "[dbo].[ShareStory_Update_Approval]";

        _data.ExecuteNonQuery(
            procName,
            inputParamMapper: delegate (SqlParameterCollection coll)
            {
                coll.AddWithValue("@Id", id);
                coll.AddWithValue("@UserId", userId);
                coll.AddWithValue("@IsApproved", isApproved);
            },
            returnParameters: null
            );
    }

    public void Delete(int id, int userId)
    {
        string procName = "[dbo].[ShareStory_Delete]";

        _data.ExecuteNonQuery(
            procName,
            inputParamMapper: delegate (SqlParameterCollection coll)
            {
                coll.AddWithValue("@Id", id);
                coll.AddWithValue("@UserId", userId);
            },
            returnParameters: null
            );
    }

    private static Story MapSingleStory(IDataReader reader, ref int i)
    {
        Story story = new Story();

        i = 0;

        story.Id = reader.GetSafeInt32(i++);
        story.Name = reader.GetSafeString(i++);
        story.Email = reader.GetSafeString(i++);
        story.StoryText = reader.GetSafeString(i++);
        string storyFileAsString = reader.GetSafeString(i++);
        if (!string.IsNullOrEmpty(storyFileAsString))
        {
            story.StoryFile = JsonConvert.DeserializeObject<List<UploadedFile>>(storyFileAsString);
        }
        story.CreatedBy = reader.GetSafeInt32(i++);
        story.IsApproved = reader.GetSafeBool(i++);
        story.ApprovedBy = reader.GetSafeInt32(i++);
        story.DateCreated = reader.GetSafeDateTime(i++);
        story.DateModified = reader.GetSafeDateTime(i++);

        return story;
    }
    private static void AddCommonParams(StoryAddRequest model, SqlParameterCollection coll)
    {
        coll.AddWithValue("@Name", model.Name);
        coll.AddWithValue("@Email", model.Email);
        coll.AddWithValue("@Story", model.Story);

    }
    private static DataTable MapFilesToTable(List<string> filesToMap)
    {
        DataTable table = new DataTable();

        table.Columns.Add("Id", typeof(Int32));

        foreach (string fileId in filesToMap)
        {
            DataRow row = table.NewRow();
            int i = 0;
            row.SetField(i++, fileId);

            table.Rows.Add(row);
        }
        return table;
    }
}
