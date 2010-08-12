# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)


    Quest.create([
        
        
        # level 1
        
       { :title=>'Contribute', :description=>'Own at least 3 pics.', :level_required=>1, :hearts_awarded=>3, :reputation_awarded=>10, :count_required=>3 },
       { :title=>'Daily Login', :description=>'Log in 3 days in a row.', :level_required=>1, :hearts_awarded=>3, :reputation_awarded=>15, :count_required=>3 },
       { :title=>'Karma', :description=>'Receive at least 5 hearts from other users.', :level_required=>1, :hearts_awarded=>3, :reputation_awarded=>15, :count_required=>5 },
       { :title=>'Popularity Contest', :description=>'Have at least 5 followers.', :level_required=>1, :hearts_awarded=>3, :reputation_awarded=>10, :count_required=>5 },
       { :title=>'Organ Donor', :description=>'Give out 10 hearts to pics you like.', :level_required=>1, :hearts_awarded=>3, :reputation_awarded=>10, :count_required=>10 },
        
        
        # level 3
        
       { :title=>'Props', :description=>'Leave a comment on 10 pics you have hearted', :level_required=>3, :hearts_awarded=>3, :reputation_awarded=>15, :count_required=>10 },
       { :title=>'Hot Pic', :description=>'Own a pic with more than 10 hearts awarded to it.', :level_required=>3, :hearts_awarded=>3, :reputation_awarded=>25, :count_required=>10 },
       { :title=>'Noteworthy', :description=>'Own a pic with more than 10 comments, excluding your own.', :level_required=>3, :hearts_awarded=>3, :reputation_awarded=>25, :count_required=>10 },
       { :title=>'Go Postal', :description=>'Have at least 10 posts on your wall, excluding your own.', :level_required=>3, :hearts_awarded=>3, :reputation_awarded=>20, :count_required=>10 },
       { :title=>'Eyecatcher', :description=>'Own a pic with more than 100 views.', :level_required=>3, :hearts_awarded=>3, :reputation_awarded=>20, :count_required=>100 },
        
        
        # level 5
        
       { :title=>'Conquistador', :description=>'Give 10 pics their first heart.', :level_required=>5, :hearts_awarded=>3, :reputation_awarded=>20, :count_required=>10 },
       { :title=>'Flash Flood', :description=>'Own a pic that was hearted 10 times within one hour of being uploaded.', :level_required=>5, :hearts_awarded=>3, :reputation_awarded=>20, :count_required=>10 },
       { :title=>'Tagfest', :description=>'Own a pic with more than 5 tags, excluding your own.', :level_required=>5, :hearts_awarded=>3, :reputation_awarded=>20, :count_required=>5 },
       { :title=>'Leveler', :description=>'Complete at least 15 quests.', :level_required=>5, :hearts_awarded=>5, :reputation_awarded=>25, :count_required=>5 },
       { :title=>'Gossip', :description=>'Own a pic that receives 10 comments within one hour of being uploaded.', :level_required=>5, :hearts_awarded=>3, :reputation_awarded=>20, :count_required=>10 },
       { :title=>'Skills', :description=>'Receive at least 500 hearts from other users.', :level_required=>5, :hearts_awarded=>5, :reputation_awarded=>20, :count_required=>500 },
        
        # level 10

       { :title=>'Hooked', :description=>'Own at least 50 pics.', :level_required=>10, :hearts_awarded=>4, :reputation_awarded=>25, :count_required=>50 },
       { :title=>'True Love', :description=>'Own a pic with more than 50 hearts awarded to it.', :level_required=>10, :hearts_awarded=>3, :reputation_awarded=>25, :count_required=>50 },
       { :title=>'Committed', :description=>'Log in 30 days in a row.', :level_required=>10, :hearts_awarded=>3, :reputation_awarded=>25, :count_required=>30 },
       { :title=>'Well Known', :description=>'Have at least 50 followers.', :level_required=>10, :hearts_awarded=>3, :reputation_awarded=>25, :count_required=>50 },
       { :title=>'Paparazzi', :description=>'Own a pic with more than 1000 views.', :level_required=>10, :hearts_awarded=>4, :reputation_awarded=>20, :count_required=>1000 },
        
        
        # level 15
        
       { :title=>'Pro', :description=>'Receive at least 1000 hearts from other users.', :level_required=>15, :hearts_awarded=>5, :reputation_awarded=>20, :count_required=>1000 },
       { :title=>'Levelest', :description=>'Complete at least 20 quests.', :level_required=>15, :hearts_awarded=>5, :reputation_awarded=>20, :count_required=>20 },
       { :title=>'Invasion', :description=>'Own a pic that was hearted 100 times within one hour of being uploaded.', :level_required=>15, :hearts_awarded=>7, :reputation_awarded=>20, :count_required=>100 },
       { :title=>'Talk of the Town', :description=>'Own a pic that receives 50 comments within one hour of being uploaded.', :level_required=>15, :hearts_awarded=>7, :reputation_awarded=>20, :count_required=>50 },
        
    
        # level 20
        
       { :title=>'Masterpiece', :description=>'Own a pic with more than 500 hearts awarded to it.', :level_required=>20, :hearts_awarded=>10, :reputation_awarded=>25, :count_required=>500 },
       { :title=>'Celebrity', :description=>'Be followed by 10 times the number of users you follow, and follow at least 10 users', :level_required=>20, :hearts_awarded=>10, :reputation_awarded=>30, :count_required=>10 },
       { :title=>'Widely Known', :description=>'Own a pic with more than 10000 views.', :level_required=>20, :hearts_awarded=>10, :reputation_awarded=>50, :count_required=>10000 },
       { :title=>'Superstar', :description=>'Have at least 500 followers.', :level_required=>20, :hearts_awarded=>10, :reputation_awarded=>25, :count_required=>500 },        
    ])