using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Sabio.Models.Requests.ShareStory
{
    public class StoryAddRequest
    {
        [Required]
        [MinLength(2)]
        [MaxLength(50)]
        public string Name { get; set; }
        [Required]
        [EmailAddress]
        public string Email { get; set; }
        [Required]
        [MinLength(20)]
        [MaxLength(3000)]
        public string Story { get; set; }
        [Required]
        public List<string> FileIds { get; set; }
    }
}
