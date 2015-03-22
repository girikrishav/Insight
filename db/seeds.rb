# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# AdminUser.destroy_all
# UserStatuses.create(name: 'Yes', description: 'Yes', rank: 1)
# UserStatuses.create(name: 'No', description: 'No', rank: 2)

# AdminUser.destroy_all
# Role.destroy_all
# Role.create(name: 'Administrator', rank: 100)
#
# # AdminUser.destroy_all
# @role = Role.find_by_name('Administrator')
# AdminUser.create(email: 'admin@example.com', password: 'password', password_confirmation: 'password', role_id: @role.id)
#
# ProjectTypes.destroy_all
# VacationReasons.destroy_all
# FlagStatuses.destroy_all
# FlagStatuses.create(name: 'Yes', description: 'Yes', rank: 1)
# FlagStatuses.create(name: 'No', description: 'No', rank: 2)
#
# InvoiceStatuses.destroy_all
# InvoiceStatuses.create(name: 'New', description: 'New', rank: 1)
# InvoiceStatuses.create(name: 'Sent', description: 'Sent', rank: 2)
# InvoiceStatuses.create(name: 'Paid', description: 'Paid', rank: 3)
# InvoiceStatuses.create(name: 'Part-paid', description: 'Part-paid', rank: 4)
# InvoiceStatuses.create(name: 'Canceled', description: 'Canceled', rank: 5)
# InvoiceStatuses.create(name: 'Hold', description: 'Hold', rank: 6)
#
# PaymentStatuses.destroy_all
# PaymentStatuses.create(name: 'New', description: 'New', rank: 1)
# PaymentStatuses.create(name: 'Received', description: 'Received', rank: 2)
# PaymentStatuses.create(name: 'Reconciled', description: 'Reconciled', rank: 3)
# PaymentStatuses.create(name: 'Part-reconciled', description: 'Part-reconciled', rank: 4)
# PaymentStatuses.create(name: 'Canceled', description: 'Canceled', rank: 5)
# PaymentStatuses.create(name: 'Hold', description: 'Hold', rank: 6)
#
# PipelineStatuses.destroy_all
# PipelineStatuses.create(name: 'New', description: 'New', rank: 1)
# PipelineStatuses.create(name: 'Discussion', description: 'Discussion', rank: 2)
# PipelineStatuses.create(name: 'Proposal', description: 'Proposal', rank: 3)
# PipelineStatuses.create(name: 'Signed', description: 'Signed', rank: 4)
# PipelineStatuses.create(name: 'Delivery', description: 'Delivery', rank: 5)
# PipelineStatuses.create(name: 'Lost', description: 'Lost', rank: 6)
# PipelineStatuses.create(name: 'Hold', description: 'Hold', rank: 7)
# PipelineStatuses.create(name: 'Canceled', description: 'Canceled', rank: 8)
#
# ProjectStatuses.destroy_all
# ProjectStatuses.create(name: 'New', description: 'New', rank: 1)
# ProjectStatuses.create(name: 'Delivery', description: 'Delivery', rank: 2)
# ProjectStatuses.create(name: 'Completed', description: 'Completed', rank: 3)
# ProjectStatuses.create(name: 'Hold', description: 'Hold', rank: 4)
# ProjectStatuses.create(name: 'Canceled', description: 'Canceled', rank: 5)
#
# # ProjectTypes.destroy_all
# ProjectTypes.create(name: 'Fixed', description: 'Fixed bid', rank: 1, is_billed: 1)
# ProjectTypes.create(name: 'TnM', description: 'Time and material', rank: 2, is_billed: 1)
# ProjectTypes.create(name: 'Internal', description: 'Internal to organization', rank: 3, is_billed: 2)
# ProjectTypes.create(name: 'Default', description: 'Overhead capture', rank: 4, is_billed: 2)
#
# Currencies.destroy_all
# Currencies.create(name: "USD", description: "US Dollar")
# Currencies.create(name: "INR", description: "Indian Rupee")
# Currencies.create(name: "SGD", description: "Singapore Dollar")
# Currencies.create(name: "JPY", description: "Japanese Yen")
# Currencies.create(name: "AED", description: "Emirates Dirham")
#
# AssociateTypes.destroy_all
# AssociateTypes.create(name: "Employee", description: "Permanent staffer", rank: 1)
# AssociateTypes.create(name: "Consultant", description: "Temporary staffer", rank: 2)
# AssociateTypes.create(name: "Intern", description: "Trainee staffer", rank: 3)