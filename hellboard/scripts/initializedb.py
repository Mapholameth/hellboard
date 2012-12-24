import os
import sys
import transaction

from sqlalchemy import engine_from_config

from pyramid.paster import (
    get_appsettings,
    setup_logging,
    )

from ..models import (
    DBSession,
    Post,
    Base,
    Thread,
    Board,
    )

def usage(argv):
    cmd = os.path.basename(argv[0])
    print('usage: %s <config_uri>\n'
          '(example: "%s development.ini")' % (cmd, cmd)) 
    sys.exit(1)

def main(argv=sys.argv):
    if len(argv) != 2:
        usage(argv)
    config_uri = argv[1]
    setup_logging(config_uri)
    settings = get_appsettings(config_uri)
    engine = engine_from_config(settings, 'sqlalchemy.')
    DBSession.configure(bind=engine)
    Base.metadata.create_all(engine)
    with transaction.manager:
        boardB = Board('b')
        boardBB = Board('bb')
        boardD = Board('d')
        DBSession.add(boardB)
        DBSession.add(boardBB)
        DBSession.add(boardD)
        DBSession.flush()
        thread = Thread(boardB.id)
        DBSession.add(thread)
        DBSession.flush()
        post = Post(u"testPost", boardB.id, thread.id)
        DBSession.add(post)
        DBSession.flush()
