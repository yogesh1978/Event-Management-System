from extensions import app, db
from models import User, Product, Cart
import os

def create_tables():
    """Create tables and add default products if the database is empty."""
    with app.app_context():
        db.create_all()
        if Product.query.count() == 0:
            default_products = [
                Product(name='Product 1', description='Description for product 1', price=19.99, image_url='https://via.placeholder.com/150'),
                Product(name='Product 2', description='Description for product 2', price=29.99, image_url='https://via.placeholder.com/150'),
                Product(name='Product 3', description='Description for product 3', price=39.99, image_url='https://via.placeholder.com/150')
            ]
            db.session.bulk_save_objects(default_products)
            db.session.commit()
            print('Database initialized with predefined products.')

if __name__ == '__main__':
    from routes import *  # Import routes to register them with the app
    

    app.run(debug=True)
    
    with app.app_context():
        create_tables()
    

