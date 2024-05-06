function consts=tide_freqs
lats = 0:.001:90;fs = sw_f(lats);
consts.m2.omega=1.4051890e-4; consts.m2.lat = lats(nearest(fs,consts.m2.omega));
consts.s2.omega=1.4544410e-4; consts.s2.lat = lats(nearest(fs,consts.s2.omega));
consts.n2.omega=1.3787970e-4; consts.n2.lat = lats(nearest(fs,consts.n2.omega));
consts.k2.omega=1.4584230e-4; consts.k2.lat = lats(nearest(fs,consts.k2.omega));
consts.k1.omega=0.7292117e-4; consts.k1.lat = lats(nearest(fs,consts.k1.omega));
consts.o1.omega=0.6759774e-4; consts.o1.lat = lats(nearest(fs,consts.o1.omega));
consts.p1.omega=0.7252295e-4; consts.p1.lat = lats(nearest(fs,consts.p1.omega));
consts.q1.omega=0.6495854e-4; consts.q1.lat = lats(nearest(fs,consts.q1.omega));

consts.m2.T=(2*pi/consts.m2.omega)/3600;
consts.s2.T=(2*pi/consts.s2.omega)/3600;
consts.n2.T=(2*pi/consts.n2.omega)/3600;
consts.k2.T=(2*pi/consts.k2.omega)/3600;
consts.k1.T=(2*pi/consts.k1.omega)/3600;
consts.o1.T=(2*pi/consts.o1.omega)/3600;
consts.p1.T=(2*pi/consts.p1.omega)/3600;
consts.q1.T=(2*pi/consts.q1.omega)/3600;

