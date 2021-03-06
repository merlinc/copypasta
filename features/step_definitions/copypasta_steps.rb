# Put your step definitions here
Given(/^a binary file at "(.*?)"$/) do |binary|
  # should probably manually make a 'file' to use
    File.exist?(binary).should == true
end

Given(/^a target directory "(.*?)" that does not already exist$/) do |target_dir|
  FileUtils.rm_rf target_dir
  FileUtils.mkdir target_dir
end

Given(/^a target directory "(.*?)" that does not already exist and should not be created$/) do |target_dir|
  FileUtils.rm_rf target_dir
  File.exist?(target_dir).should == false
end

Then(/^the directory "(.*?)" should be created$/) do |target_dir|
  File.exist?(target_dir).should == true
end

Then(/^the binary file "(.*?)" should be copied into the directory "(.*?)"$/) do |binary, target_dir|
  new_binary = File.join(target_dir, File.basename(binary))
  File.exist?(new_binary).should == true
end

Then(/^the directory "(.*?)" should not be created$/) do |arg1|
  File.exist?(arg1).should == false
end

Then(/^the binary file "(.*?)" should not be copied into the directory "(.*?)"$/) do |binary, target_dir|
  absolute_binary_path = File.join(target_dir, File.basename(binary))
  File.exist?(absolute_binary_path) == false
end

Given(/^the following dependencies:$/) do |table|
  # table is a Cucumber::Ast::Table
end

Then(/^the copied binary file "(.*?)" should not be relinked$/) do |arg1|
end