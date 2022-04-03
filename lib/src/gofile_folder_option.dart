/// Used in [GoFileClient.setFolderOption]
/// You can use only one option at a time
enum GoFileFolderOption {
  /// Can be true or false
  public,

  /// Value must be the password
  password,

  /// The description for the folder
  description,

  /// Expiration date in the form of unix timestamp
  expire,

  /// Comma separated list of tags
  tags
}
