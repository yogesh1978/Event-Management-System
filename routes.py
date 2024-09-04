from flask import render_template, redirect, url_for, request, flash, session
from flask_mail import Mail, Message
from run import app, db
from models import User, Product, Cart
from forms import RegistrationForm, LoginForm, ChangePasswordForm, ForgotPasswordForm, ResetPasswordForm, AddToCartForm, CheckoutForm
import random
import string

# Initialize Flask-Mail
mail = Mail(app)

# Generate a random OTP
def generate_otp():
    return ''.join(random.choices(string.digits, k=6))

@app.route('/register', methods=['GET', 'POST'])
def register():
    form = RegistrationForm()
    if form.validate_on_submit():
        hashed_password = form.password.data  # Hash the password in a real app
        new_user = User(username=form.username.data, email=form.email.data, password=hashed_password)
        db.session.add(new_user)
        db.session.commit()
        print('User created successfully.')
        flash('Account created successfully! You can now log in.', 'success')
        return redirect(url_for('login'))
    print('Form errors:', form.errors)
    return render_template('register.html', form=form)


# Route for user login
@app.route('/login', methods=['GET', 'POST'])
def login():
    form = LoginForm()
    if form.validate_on_submit():
        user = User.query.filter_by(username=form.username.data).first()
        if user and user.password == form.password.data:  # Check hashed password in a real app
            otp = generate_otp()
            session['otp'] = otp
            session['user_id'] = user.id  # Set user ID in session
            if user.email:
                msg = Message('Your OTP Code', sender='your-email@example.com', recipients=[user.email])
                msg.body = f'Your OTP code is {otp}'
                try:
                    mail.send(msg)
                except:
                    flash('Failed to send OTP. Check your email settings.', 'danger')
                    print(otp)
                    return redirect(url_for('otp_verification'))
            return redirect(url_for('otp_verification'))
        flash('Login unsuccessful. Check your username and password.', 'danger')
    return render_template('login.html', form=form)

# Route for OTP verification
@app.route('/otp-verification', methods=['GET', 'POST'])
def otp_verification():
    if request.method == 'POST':
        otp = request.form.get('otp')
        if otp == session.get('otp'):
            user_id = session.get('user_id')
            # Successful login, redirect to home or dashboard
            flash('OTP verified successfully! Welcome back.', 'success')
            return redirect(url_for('products'))
        flash('Invalid OTP. Please try again.', 'danger')
    return render_template('otp_verification.html')

# Route for changing password
@app.route('/change-password', methods=['GET', 'POST'])
def change_password():
    form = ChangePasswordForm()
    if form.validate_on_submit():
        user = User.query.get(session['user_id'])  # Dynamic user ID
        if user and user.password == form.current_password.data:  # Check hashed password in a real app
            user.password = form.new_password.data  # Hash the new password
            db.session.commit()
            flash('Password updated successfully!', 'success')
            return redirect(url_for('home'))
        flash('Current password is incorrect.', 'danger')
    return render_template('change_password.html', form=form)

# Route for requesting a forgotten password OTP
@app.route('/forgot-password', methods=['GET', 'POST'])
def forgot_password():
    form = ForgotPasswordForm()
    if form.validate_on_submit():
        user = User.query.filter_by(username=form.username.data).first()
        if user:
            otp = generate_otp()
            session['otp'] = otp
            session['user_id'] = user.id
            if user.email:
                msg = Message('Password Reset OTP', sender='your-email@example.com', recipients=[user.email])
                msg.body = f'Your OTP code is {otp}'
                try:
                    mail.send(msg)
                except:
                    flash('Failed to send OTP. Check your email settings.', 'danger')
                    return redirect(url_for('reset_password'))
            flash('OTP sent successfully to your email. Please check your inbox.', 'info')
            return redirect(url_for('reset_password'))
        flash('No user found with this username.', 'danger')
    return render_template('forgot_password.html', form=form)

# Route for resetting the password
@app.route('/reset-password', methods=['GET', 'POST'])
def reset_password():
    form = ResetPasswordForm()
    if form.validate_on_submit():
        otp = form.otp.data
        if otp == session.get('otp'):
            user = User.query.get(session.get('user_id'))
            user.password = form.new_password.data  # Hash the new password
            db.session.commit()
            session.pop('otp', None)
            session.pop('user_id', None)
            flash('Password reset successfully. You can now log in.', 'success')
            return redirect(url_for('login'))
        flash('Invalid OTP. Please try again.', 'danger')
    return render_template('reset_password.html', form=form)

# Route for listing all users (admin only)
@app.route('/users')
def list_users():
    users = User.query.all()
    return render_template('list_users.html', users=users)

# Route for displaying the product catalog
@app.route('/products')
def products():
    form = AddToCartForm()  # Initialize the form
    products = Product.query.all()
    return render_template('products.html', products=products, form=form)

# Route for adding a product to the cart
@app.route('/add-to-cart/<int:product_id>', methods=['POST'])
def add_to_cart(product_id):
    form = AddToCartForm()

    print('Form data:', form.data)  # Print form data for debugging
    print('User ID from session:', session.get('user_id'))

    if form.validate_on_submit():
        quantity = form.quantity.data
        user_id = session.get('user_id')
        print(f'Adding product {product_id} with quantity {quantity} for user {user_id}')

        if user_id:
            existing_cart_item = Cart.query.filter_by(user_id=user_id, product_id=product_id).first()
            if existing_cart_item:
                existing_cart_item.quantity += quantity
                print("Cart item quantity updated.")
            else:
                cart_item = Cart(user_id=user_id, product_id=product_id, quantity=quantity)
                db.session.add(cart_item)
                print("New cart item added.")
            
            db.session.commit()
            print("Cart changes committed.")
            flash('Product added to cart!', 'success')
        else:
            flash('You need to be logged in to add items to the cart.', 'danger')

    return render_template('products.html', products=Product.query.all(), form=form)


@app.route('/logout')
def logout():
    session.pop('user_id', None)
    flash('You have been logged out.', 'info')
    return redirect(url_for('home'))


# Route for checking out and making payment
@app.route('/checkout', methods=['GET', 'POST'])
def checkout():
    form = CheckoutForm()

    if form.validate_on_submit():
        address = form.address.data
        payment_method = form.payment_method.data
        user_id = session.get('user_id')

        # Debugging print statements
        print('Address:', address)
        print('Payment Method:', payment_method)
        print('User ID:', user_id)

        # Check if user_id is valid
        if not user_id:
            print('No user_id found in session.')
            flash('You need to be logged in to checkout.', 'danger')
            return redirect(url_for('login'))

        # Clear the cart after successful checkout
        Cart.query.filter_by(user_id=user_id).delete()
        db.session.commit()

        print('Cart cleared successfully.')

        flash('Order placed successfully!', 'success')
        return redirect(url_for('home'))

    # Retrieve cart items for display
    user_id = session.get('user_id')
    cart_items = Cart.query.filter_by(user_id=user_id).all() if user_id else []

    return render_template('checkout.html', form=form, cart_items=cart_items)




# Route for the home page (or dashboard)
@app.route('/')
def home():
    return render_template('home.html')
