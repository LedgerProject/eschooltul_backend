describe('User login', () => {
  it('works for director', () => {
    const password = 'password123';
    cy.appFactories([['create', 'user', 'director', { password }]]).then((results) => {
      const user = results[0];
      cy.visit('/');

      cy.get('#user_email').type(user.email);
      cy.get('#user_password').type(password);
      cy.get('.unauthenticated-submit').click();

      cy.contains('My school');
    });
  });
});
