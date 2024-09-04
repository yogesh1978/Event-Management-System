from extensions import db


# Define the User model
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(150), unique=True, nullable=False)
    password = db.Column(db.String(150), nullable=False)
    email = db.Column(db.String(150), unique=True, nullable=False)
    is_admin = db.Column(db.Boolean, default=False)  # Assuming we have an admin flag
    cart_items = db.relationship('Cart', backref='owner', lazy=True)

    def __repr__(self):
        return f'<User {self.username}>'

# Define the Product model
class Product(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(150), nullable=False)
    description = db.Column(db.Text, nullable=False)
    price = db.Column(db.Float, nullable=False)
    image_url = db.Column(db.String(255), nullable=True)

    def __repr__(self):
        return f'<Product {self.name}>'

# Define the Cart model
class Cart(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    product_id = db.Column(db.Integer, db.ForeignKey('product.id'), nullable=False)
    quantity = db.Column(db.Integer, nullable=False, default=1)

    # Define relationships
    product = db.relationship('Product', backref='cart_entries', lazy=True)

    def __repr__(self):
        return f'<Cart {self.user_id} - {self.product_id}>'

# Initialize the database with predefined rows
def init_db():
    with db.app.app_context():
        db.create_all()
        if Product.query.count() == 0:
            products = [
                Product(name='Product 1', description='Description for Product 1', price=10.99, image_url='http://placehold.it/150x150'),
                Product(name='Product 2', description='Description for Product 2', price=20.99, image_url='http://placehold.it/150x150'),
                Product(name='Product 3', description='Description for Product 3', price=30.99, image_url='http://placehold.it/150x150'),
            ]
            db.session.bulk_save_objects(products)
            db.session.commit()
            print('Database initialized with predefined products.')
