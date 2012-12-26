from pyramid.config import Configurator
from sqlalchemy import engine_from_config

from .models import (
    DBSession,
    Base,
    )

def main(global_config, **settings):
    """ This function returns a Pyramid WSGI application.
    """
    engine = engine_from_config(settings, 'sqlalchemy.')
    DBSession.configure(bind=engine)
    Base.metadata.bind = engine
    config = Configurator(settings=settings)
    config.add_static_view('static', 'static', cache_max_age=3600)
    config.add_route('view_root', '/')
    config.add_route('view_board', '/{board}')
    config.add_route('view_thread', '/{board}/{thread}')
    config.add_route('view_post', '/{board}/{thread}/{post}')
    #config.add_route('search_site', '/search')
    #config.add_route('search_board', '/{board}/search')
    #config.add_route('')
    config.scan()
    return config.make_wsgi_app()

