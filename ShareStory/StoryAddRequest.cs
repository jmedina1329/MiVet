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

