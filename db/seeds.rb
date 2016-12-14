# Role.create([{ name: 'admin', title: 'Адміністратор' }, { name: 'manager', title: 'Менеджер' }, { name: 'client', title: 'Клієнт' }, { name: 'guest', title: 'Гість' }])

# User.create(login: 'Kasumi', email: 'gavrileypetro@gmail.com', password: 'qwerty', name: 'Kami', role_id: 1)

# args = Array.new

# 5.times { args << { name: 'Lorem ipsum dolor sit amet', parent_id: 0 } }

# categories = Category.create(args)

# args_nested = Array.new

# categories.each { |category| 7.times { args_nested << { name: 'Lorem ipsum dolor sit amet', parent_id: category.id } } }

# Category.create(args_nested)

# category = Category.create(name: "Ноутбуки", parent_id: 0)
# category = Category.create(name: "Компютери", parent_id: 0)
# category = Category.create(name: "Комплектуючі", parent_id: 0)
# category = Category.create(name: "Планшети", parent_id: 0)
# category = Category.create(name: "Оргтехніка", parent_id: 0)
# category = Category.create(name: "Програмне забеспечення", parent_id: 0)

# Category.create([
# 		{ name: "Asus", parent_id: 1 },
# 		{ name: "Acer", parent_id: 1 },
# 		{ name: "HP (Hewlett Packard)", parent_id: 1 },
# 		{ name: "Lenovo", parent_id: 1 },
# 		{ name: "Dell", parent_id: 1 },
# 		{ name: "Apple", parent_id: 1 }
# 	])



# Category.create([
# 		{ name: "Неттопи і моноблоки", parent_id: 2 },
# 		{ name: "Сервери", parent_id: 2 },
# 		{ name: "Монитори", parent_id: 2 },
# 		{ name: "Клавиатуры и мыши", parent_id: 2 },
# 		{ name: "Акустика", parent_id: 2 }
# 	])



# 30.times { Product.create(
# 	title: 'Lorem ipsum dolor', 
# 	description: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quaerat rerum necessitatibus, est sit qui! Deserunt, voluptatibus eum aut consectetur tempore minus quia nobis autem sit praesentium dolorum facilis, magnam fugiat! Quia deserunt pariatur consequatur ipsum recusandae soluta delectus aperiam',
# 	user: User.find(1),
# 	price: 16000
# ) }

Product.delete_all

12.times {
	Product.create(
		title: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit',
		user_id: 1,
		price: Random.new.rand(10..99) * 100,
		description: "<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit:</p>
<ul>
	<li>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Mollitia quaerat quae, ducimus, praesentium enim nam.</li>
	<li>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Mollitia quaerat quae, ducimus, praesentium enim nam.</li>
	<li>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Mollitia quaerat quae, ducimus, praesentium enim nam.</li>
	<li>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Mollitia quaerat quae, ducimus, praesentium enim nam.</li>
	<li>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Mollitia quaerat quae, ducimus, praesentium enim nam.</li>
	<li>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Mollitia quaerat quae, ducimus, praesentium enim nam.</li>
	<li>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Mollitia quaerat quae, ducimus, praesentium enim nam.</li>
	<li>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Mollitia quaerat quae, ducimus, praesentium enim nam.</li>
	<li>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Mollitia quaerat quae, ducimus, praesentium enim nam.</li>
	<li>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Mollitia quaerat quae, ducimus, praesentium enim nam.</li>
	<li>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Mollitia quaerat quae, ducimus, praesentium enim nam.</li>
	<li>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Mollitia quaerat quae, ducimus, praesentium enim nam.</li>
	<li>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Mollitia quaerat quae, ducimus, praesentium enim nam.</li>
	<li>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Mollitia quaerat quae, ducimus, praesentium enim nam.</li>
	<li>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Mollitia quaerat quae, ducimus, praesentium enim nam.</li>
</ul>"
	)	
}