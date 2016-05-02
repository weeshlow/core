Feature: provisioning
	Background:
		Given using api version "1"

	Scenario: Getting an not existing user
		Given As an "admin"
		When sending "GET" to "/cloud/users/test"
		Then the OCS status code should be "998"
		And the HTTP status code should be "200"

	Scenario: Listing all users
		Given As an "admin"
		When sending "GET" to "/cloud/users"
		Then the OCS status code should be "100"
		And the HTTP status code should be "200"

	Scenario: Create a user
		Given As an "admin"
		And user "brand-new-user" does not exist
		When sending "POST" to "/cloud/users" with
			| userid | brand-new-user |
			| password | 123456 |
		Then the OCS status code should be "100"
		And the HTTP status code should be "200"
		And user "brand-new-user" exists

	Scenario: Create an existing user
		Given As an "admin"
		And user "brand-new-user" exists
		When sending "POST" to "/cloud/users" with
			| userid | brand-new-user |
			| password | 123456 |
		Then the OCS status code should be "102"
		And the HTTP status code should be "200"

	Scenario: Get an existing user
		Given As an "admin"
		When sending "GET" to "/cloud/users/brand-new-user"
		Then the OCS status code should be "100"
		And the HTTP status code should be "200"

	Scenario: Getting all users
		Given As an "admin"
		And user "brand-new-user" exists
		And user "admin" exists
		When sending "GET" to "/cloud/users"
		Then users returned are
			| brand-new-user |
			| admin |

	Scenario: Edit a user
		Given As an "admin"
		And user "brand-new-user" exists
		When sending "PUT" to "/cloud/users/brand-new-user" with
			| key | quota |
			| value | 12MB |
			| key | email |
			| value | brand-new-user@gmail.com |
		Then the OCS status code should be "100"
		And the HTTP status code should be "200"
		And user "brand-new-user" exists

	Scenario: Create a group
		Given As an "admin"
		And group "new-group" does not exist
		When sending "POST" to "/cloud/groups" with
			| groupid | new-group |
			| password | 123456 |
		Then the OCS status code should be "100"
		And the HTTP status code should be "200"
		And group "new-group" exists

	Scenario: Create a group with special characters
		Given As an "admin"
		And group "España" does not exist
		When sending "POST" to "/cloud/groups" with
			| groupid | España |
			| password | 123456 |
		Then the OCS status code should be "100"
		And the HTTP status code should be "200"
		And group "España" exists

	Scenario: adding user to a group without sending the group
		Given As an "admin"
		And user "brand-new-user" exists
		When sending "POST" to "/cloud/users/brand-new-user/groups" with
			| groupid |  |
		Then the OCS status code should be "101"
		And the HTTP status code should be "200"

	Scenario: adding user to a group which doesn't exist
		Given As an "admin"
		And user "brand-new-user" exists
		And group "not-group" does not exist
		When sending "POST" to "/cloud/users/brand-new-user/groups" with
			| groupid | not-group |
		Then the OCS status code should be "102"
		And the HTTP status code should be "200"

	Scenario: adding user to a group without privileges
		Given As an "brand-new-user"
		When sending "POST" to "/cloud/users/brand-new-user/groups" with
			| groupid | new-group |
		Then the OCS status code should be "997"
		And the HTTP status code should be "401"

	Scenario: adding user to a group
		Given As an "admin"
		And user "brand-new-user" exists
		And group "new-group" exists
		When sending "POST" to "/cloud/users/brand-new-user/groups" with
			| groupid | new-group |
		Then the OCS status code should be "100"
		And the HTTP status code should be "200"

	Scenario: getting groups of an user
		Given As an "admin"
		And user "brand-new-user" exists
		And group "new-group" exists
		When sending "GET" to "/cloud/users/brand-new-user/groups"
		Then groups returned are
			| new-group |
		And the OCS status code should be "100"

	Scenario: adding a user which doesn't exist to a group
		Given As an "admin"
		And user "not-user" does not exist
		And group "new-group" exists
		When sending "POST" to "/cloud/users/not-user/groups" with
			| groupid | new-group |
		Then the OCS status code should be "103"
		And the HTTP status code should be "200"

	Scenario: getting a group
		Given As an "admin"
		And group "new-group" exists
		When sending "GET" to "/cloud/groups/new-group"
		Then the OCS status code should be "100"
		And the HTTP status code should be "200"

	Scenario: Getting all groups
		Given As an "admin"
		And group "new-group" exists
		And group "admin" exists
		When sending "GET" to "/cloud/groups"
		Then groups returned are
			| España |
			| admin |
			| new-group |

	Scenario: create a subadmin
		Given As an "admin"
		And user "brand-new-user" exists
		And group "new-group" exists
		When sending "POST" to "/cloud/users/brand-new-user/subadmins" with
			| groupid | new-group |
		Then the OCS status code should be "100"
		And the HTTP status code should be "200"

	Scenario: get users using a subadmin
		Given As an "admin"
		And user "brand-new-user" exists
		And group "new-group" exists
		And user "brand-new-user" belongs to group "new-group"
		And user "brand-new-user" is subadmin of group "new-group"
		And As an "brand-new-user"
		When sending "GET" to "/cloud/users"
		Then users returned are
			| brand-new-user |
		And the OCS status code should be "100"
		And the HTTP status code should be "200"

	Scenario: removing a user from a group which doesn't exists
		Given As an "admin"
		And user "brand-new-user" exists
		And group "not-group" does not exist
		When sending "DELETE" to "/cloud/users/brand-new-user/groups" with
			| groupid | not-group |
		Then the OCS status code should be "102"

	Scenario: removing a user from a group
		Given As an "admin"
		And user "brand-new-user" exists
		And group "new-group" exists
		And user "brand-new-user" belongs to group "new-group"
		When sending "DELETE" to "/cloud/users/brand-new-user/groups" with
			| groupid | new-group |
		Then the OCS status code should be "100"
		And user "brand-new-user" does not belong to group "new-group"

	Scenario: create a subadmin using a user which not exist
		Given As an "admin"
		And user "not-user" does not exist
		And group "new-group" exists
		When sending "POST" to "/cloud/users/not-user/subadmins" with
			| groupid | new-group |
		Then the OCS status code should be "101"
		And the HTTP status code should be "200"

	Scenario: create a subadmin using a group which not exist
		Given As an "admin"
		And user "brand-new-user" exists
		And group "not-group" does not exist
		When sending "POST" to "/cloud/users/brand-new-user/subadmins" with
			| groupid | not-group |
		Then the OCS status code should be "102"
		And the HTTP status code should be "200"

	Scenario: Getting subadmin groups
		Given As an "admin"
		And user "brand-new-user" exists
		And group "new-group" exists
		When sending "GET" to "/cloud/users/brand-new-user/subadmins"
		Then subadmin groups returned are
			| new-group |
		Then the OCS status code should be "100"
		And the HTTP status code should be "200"

	Scenario: Getting subadmin groups of a user which not exist
		Given As an "admin"
		And user "not-user" does not exist
		And group "new-group" exists
		When sending "GET" to "/cloud/users/not-user/subadmins"
		Then the OCS status code should be "101"
		And the HTTP status code should be "200"

	Scenario: Getting subadmin users of a group
		Given As an "admin"
		And user "brand-new-user" exists
		And group "new-group" exists
		When sending "GET" to "/cloud/groups/new-group/subadmins"
		Then subadmin users returned are
			| brand-new-user |
		And the OCS status code should be "100"
		And the HTTP status code should be "200"

	Scenario: Getting subadmin users of a group which doesn't exist
		Given As an "admin"
		And user "brand-new-user" exists
		And group "not-group" does not exist
		When sending "GET" to "/cloud/groups/not-group/subadmins"
		Then the OCS status code should be "101"
		And the HTTP status code should be "200"

	Scenario: Removing subadmin from a group
		Given As an "admin"
		And user "brand-new-user" exists
		And group "new-group" exists
		And user "brand-new-user" is subadmin of group "new-group"
		When sending "DELETE" to "/cloud/users/brand-new-user/subadmins" with
			| groupid | new-group |
		And the OCS status code should be "100"
		And the HTTP status code should be "200"

	Scenario: Delete a user
		Given As an "admin"
		And user "brand-new-user" exists
		When sending "DELETE" to "/cloud/users/brand-new-user" 
		Then the OCS status code should be "100"
		And the HTTP status code should be "200"
		And user "brand-new-user" does not exist

	Scenario: Delete a group
		Given As an "admin"
		And group "new-group" exists
		When sending "DELETE" to "/cloud/groups/new-group"
		Then the OCS status code should be "100"
		And the HTTP status code should be "200"
		And group "new-group" does not exist

	Scenario: Delete a group with special characters
	    Given As an "admin"
		And group "España" exists
		When sending "DELETE" to "/cloud/groups/España"
		Then the OCS status code should be "100"
		And the HTTP status code should be "200"
		And group "España" does not exist

	Scenario: get enabled apps
		Given As an "admin"
		When sending "GET" to "/cloud/apps?filter=enabled"
		Then the OCS status code should be "100"
		And the HTTP status code should be "200"
		And apps returned are
			| comments |
			| core |
			| dav |
			| federatedfilesharing |
			| federation |
			| files |
			| files_sharing |
			| files_trashbin |
			| files_versions |
			| provisioning_api |
			| systemtags |
			| updatenotification |
			| files_external |

	Scenario: get app info
		Given As an "admin"
		When sending "GET" to "/cloud/apps/files"
		Then the OCS status code should be "100"
		And the HTTP status code should be "200"

#	Scenario: enable an app
#		Given As an "admin"
#		And app "comments" is disabled
#		When sending "POST" to "/cloud/apps/comments"
#		Then the OCS status code should be "100"
#		And the HTTP status code should be "200"
#		And app "comments" is enabled
#
#	Scenario: disable an app
#		Given As an "admin"
#		And app "comments" is enabled
#		When sending "DELETE" to "/cloud/apps/comments"
#		Then the OCS status code should be "100"
#		And the HTTP status code should be "200"
#		And app "comments" is disabled

	Scenario: disable an user
		Given As an "admin"
		And user "user1" exists
		When sending "PUT" to "/cloud/users/user1/disable"
		Then the OCS status code should be "100"
		And the HTTP status code should be "200"
		And user "user1" is disabled

	Scenario: enable an user
		Given As an "admin"
		And user "user1" exists
		And assure user "user1" is disabled
		When sending "PUT" to "/cloud/users/user1/enable"
		Then the OCS status code should be "100"
		And the HTTP status code should be "200"
		And user "user1" is enabled

	Scenario: Subadmin should be able to enable or disable an user in their group
		Given As an "admin"
		And user "subadmin" exists
		And user "user1" exists
		And group "new-group" exists
		And user "subadmin" belongs to group "new-group"
		And user "user1" belongs to group "new-group"
		And Assure user "subadmin" is subadmin of group "new-group"
		And As an "subadmin"
		When sending "PUT" to "/cloud/users/user1/disable"
		Then the OCS status code should be "100"
		Then the HTTP status code should be "200"
		And As an "admin"
		And user "user1" is disabled

	Scenario: Subadmin should not be able to enable or disable an user not in their group
		Given As an "admin"
		And user "subadmin" exists
		And user "user1" exists
		And group "new-group" exists
		And group "another-group" exists
		And user "subadmin" belongs to group "new-group"
		And user "user1" belongs to group "another-group"
		And Assure user "subadmin" is subadmin of group "new-group"
		And As an "subadmin"
		When sending "PUT" to "/cloud/users/user1/disable"
		Then the OCS status code should be "997"
		Then the HTTP status code should be "401"
		And As an "admin"
		And user "user1" is enabled

	Scenario: Subadmins should not be able to disable users that have admin permissions in their group
		Given As an "admin"
		And user "another-admin" exists
		And user "subadmin" exists
		And group "new-group" exists
		And user "another-admin" belongs to group "admin"
		And user "subadmin" belongs to group "new-group"
		And user "another-admin" belongs to group "new-group"
		And Assure user "subadmin" is subadmin of group "new-group"
		And As an "subadmin"
		When sending "PUT" to "/cloud/users/another-admin/disable"
		Then the OCS status code should be "997"
		Then the HTTP status code should be "401"
		And As an "admin"
		And user "another-admin" is enabled

	Scenario: Admin can disable another admin user
		Given As an "admin"
		And user "another-admin" exists
		And user "another-admin" belongs to group "admin"
		When sending "PUT" to "/cloud/users/another-admin/disable"
		Then the OCS status code should be "100"
		Then the HTTP status code should be "200"
		And user "another-admin" is disabled

	Scenario: Admin can enable another admin user
		Given As an "admin"
		And user "another-admin" exists
		And user "another-admin" belongs to group "admin"
		And assure user "another-admin" is disabled
		When sending "PUT" to "/cloud/users/another-admin/enable"
		Then the OCS status code should be "100"
		Then the HTTP status code should be "200"
		And user "another-admin" is enabled

	Scenario: Admin can disable subadmins in the same group
		Given As an "admin"
		And user "subadmin" exists
		And group "new-group" exists
		And user "subadmin" belongs to group "new-group"
		And user "admin" belongs to group "new-group"
		And Assure user "subadmin" is subadmin of group "new-group"
		When sending "PUT" to "/cloud/users/subadmin/disable"
		Then the OCS status code should be "100"
		Then the HTTP status code should be "200"
		And user "subadmin" is disabled

	Scenario: Admin can enable subadmins in the same group
		Given As an "admin"
		And user "subadmin" exists
		And group "new-group" exists
		And user "subadmin" belongs to group "new-group"
		And user "admin" belongs to group "new-group"
		And Assure user "subadmin" is subadmin of group "new-group"
		And assure user "another-admin" is disabled
		When sending "PUT" to "/cloud/users/subadmin/disable"
		Then the OCS status code should be "100"
		Then the HTTP status code should be "200"
		And user "subadmin" is disabled

	Scenario: Admin user cannot disable himself
		Given As an "admin"
		And user "another-admin" exists
		And user "another-admin" belongs to group "admin"
		And As an "another-admin"
		When sending "PUT" to "/cloud/users/another-admin/disable"
		Then the OCS status code should be "101"
		And the HTTP status code should be "200"
		And As an "admin"
		And user "another-admin" is enabled

	Scenario:Admin user cannot enable himself
		Given As an "admin"
		And user "another-admin" exists
		And user "another-admin" belongs to group "admin"
		And assure user "another-admin" is disabled
		And As an "another-admin"
		When sending "PUT" to "/cloud/users/another-admin/enable"
		And As an "admin"
		Then user "another-admin" is disabled

	Scenario: disable an user with a regular user
		Given As an "admin"
		And user "user1" exists
		And user "user2" exists
		And As an "user1"
		When sending "PUT" to "/cloud/users/user2/disable"
		Then the OCS status code should be "997"
		And the HTTP status code should be "401"
		And As an "admin"
		And user "user2" is enabled

	Scenario: enable an user with a regular user
		Given As an "admin"
		And user "user1" exists
		And user "user2" exists
		And assure user "user2" is disabled
		And As an "user1"
		When sending "PUT" to "/cloud/users/user2/enable"
		Then the OCS status code should be "997"
		And the HTTP status code should be "401"
		And As an "admin"
		And user "user2" is disabled

	Scenario: Subadmin should not be able to disable himself
		Given As an "admin"
		And user "subadmin" exists
		And group "new-group" exists
		And user "subadmin" belongs to group "new-group"
		And Assure user "subadmin" is subadmin of group "new-group"
		And As an "subadmin"
		When sending "PUT" to "/cloud/users/subadmin/disable"
		Then the OCS status code should be "101"
		Then the HTTP status code should be "200"
		And As an "admin"
		And user "subadmin" is enabled

	Scenario: Subadmin should not be able to enable himself
		Given As an "admin"
		And user "subadmin" exists
		And group "new-group" exists
		And user "subadmin" belongs to group "new-group"
		And Assure user "subadmin" is subadmin of group "new-group"
		And assure user "subadmin" is disabled
		And As an "subadmin"
		When sending "PUT" to "/cloud/users/subadmin/enabled"
		And As an "admin"
		And user "subadmin" is disabled

	Scenario: a subadmin can add users to groups the subadmin is responsible for
		Given As an "admin"
		And user "subadmin" exists
		And user "brand-new-user" exists
		And group "new-group" exists
		And Assure user "subadmin" is subadmin of group "new-group"
		And As an "subadmin"
		When sending "POST" to "/cloud/users/brand-new-user/groups" with
			| groupid | new-group |
		Then the OCS status code should be "100"
		And the HTTP status code should be "200"
		And As an "admin"
		And check that user "brand-new-user" belongs to group "new-group"

	Scenario: a subadmin cannot add users to groups the subadmin is not responsible for
		Given As an "admin"
		And user "other-subadmin" exists
		And user "brand-new-user" exists
		And group "new-group" exists
		And group "other-group" exists
		And Assure user "other-subadmin" is subadmin of group "other-group"
		And As an "other-subadmin"
		When sending "POST" to "/cloud/users/brand-new-user/groups" with
			| groupid | new-group |
		Then the OCS status code should be "104"
		And the HTTP status code should be "200"
		And As an "admin"
		And check that user "brand-new-user" does not belong to group "new-group"

	Scenario: a subadmin can remove users to groups the subadmin is responsible for
		Given As an "admin"
		And user "subadmin" exists
		And user "brand-new-user" exists
		And group "new-group" exists
		And user "brand-new-user" belongs to group "new-group"
		And Assure user "subadmin" is subadmin of group "new-group"
		And As an "subadmin"
		When sending "DELETE" to "/cloud/users/brand-new-user/groups" with
			| groupid | new-group |
		Then the OCS status code should be "100"
		And the HTTP status code should be "200"
		And As an "admin"
		And check that user "brand-new-user" does not belong to group "new-group"

	Scenario: a subadmin cannot remove users to groups the subadmin is not responsible for
		Given As an "admin"
		And user "other-subadmin" exists
		And user "brand-new-user" exists
		And group "new-group" exists
		And group "other-group" exists
		And user "brand-new-user" belongs to group "new-group"
		And Assure user "other-subadmin" is subadmin of group "other-group"
		And As an "other-subadmin"
		When sending "DELETE" to "/cloud/users/brand-new-user/groups" with
			| groupid | new-group |
		Then the OCS status code should be "104"
		And the HTTP status code should be "200"
		And As an "admin"
		And check that user "brand-new-user" belongs to group "new-group"

	Scenario: Making a web request with an enabled user
	    Given As an "admin"
		And user "user0" exists
		And As an "user0"
		When sending "GET" to "/index.php/apps/files"
		Then the HTTP status code should be "200"

	Scenario: Making a web request with a disabled user
	    Given As an "admin"
		And user "user0" exists
		And assure user "user0" is disabled
		And As an "user0"
		When sending "GET" to "/index.php/apps/files"
		Then the OCS status code should be "999"
    	And the HTTP status code should be "200"

