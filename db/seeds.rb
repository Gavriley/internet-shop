# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Role.create([{ name: 'admin', title: 'Адміністратор' }, { name: 'manager', title: 'Менеджер' }, { name: 'client', title: 'Клієнт' }, { name: 'guest', title: 'Гість' }])

category = Category.create(name: "Ноутбуки", parent_id: 0)
category = Category.create(name: "Компютери", parent_id: 0)
category = Category.create(name: "Комплектуючі", parent_id: 0)
category = Category.create(name: "Планшети", parent_id: 0)
category = Category.create(name: "Оргтехніка", parent_id: 0)
category = Category.create(name: "Програмне забеспечення", parent_id: 0)

Category.create([
		{ name: "Asus", parent_id: 1 },
		{ name: "Acer", parent_id: 1 },
		{ name: "HP (Hewlett Packard)", parent_id: 1 },
		{ name: "Lenovo", parent_id: 1 },
		{ name: "Dell", parent_id: 1 },
		{ name: "Apple", parent_id: 1 }
	])



Category.create([
		{ name: "Неттопи і моноблоки", parent_id: 2 },
		{ name: "Сервери", parent_id: 2 },
		{ name: "Монитори", parent_id: 2 },
		{ name: "Клавиатуры и мыши", parent_id: 2 },
		{ name: "Акустика", parent_id: 2 }
	])

