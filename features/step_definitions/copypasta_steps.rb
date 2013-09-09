# Put your step definitions here
Given(/^a binary file at "(.*?)"$/) do |binary|
    File.exist?(binary).should == true
end

Then(/^the binary file "(.*?)" should be copied into the directory "(.*?)"$/) do |binary, target_dir|
  new_binary = File.join(target_dir, File.basename(binary))

  File.exist?(target_dir).should == true
  File.exist?(new_binary).should == true

  pending # express the regexp above with the code you wish you had
end