from sqlalchemy import (
    Column,
    Integer,
    Text,
    )

from sqlalchemy.ext.declarative import declarative_base

from sqlalchemy.orm import (
    scoped_session,
    sessionmaker,
    )

from zope.sqlalchemy import ZopeTransactionExtension

DBSession = scoped_session(sessionmaker(extension=ZopeTransactionExtension()))
Base = declarative_base()

class Post(Base):
    """Textboard post"""
    __tablename__ = 'posts'
    id = Column(Integer, primary_key=True, unique = True)
    text = Column(Text)
    formatted_text = Column(Text)
    def __init__(self, text):
        self.text = text
        self.formatted_text = ''