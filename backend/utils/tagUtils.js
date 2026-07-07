const sanitizeTags = (tags) => {

  // If tags missing
  if (!tags || !Array.isArray(tags)) {
    return [];
  }

  // Normalize tags
  let cleanedTags = tags.map(tag =>
    tag.trim().toLowerCase()
  );

  // Remove empty tags
  cleanedTags = cleanedTags.filter(tag =>
    tag.length > 0
  );

  // Remove duplicates
  cleanedTags = [...new Set(cleanedTags)];

  // Limit tag length
  cleanedTags = cleanedTags.filter(tag =>
    tag.length <= 10
  );

  // Maximum 5 tags
  cleanedTags = cleanedTags.slice(0, 5);

  return cleanedTags;
};

module.exports = sanitizeTags;