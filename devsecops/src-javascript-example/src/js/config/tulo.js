const isLoggedIn = () => (typeof window.Tulo !== 'undefined' && window.Tulo.logged_in());

export default isLoggedIn;
