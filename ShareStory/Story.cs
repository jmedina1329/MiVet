using Sabio.Models.Domain.File;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Sabio.Models.Domain.ShareStory
{
    public class Story
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public string StoryText { get; set; }
        public List<UploadedFile> StoryFile { get; set; }
        public int CreatedBy { get; set; }
        public bool IsApproved { get; set; }
        public int ApprovedBy { get; set; }
        public DateTime DateCreated { get; set; }
        public DateTime DateModified { get; set; }
    }
}
